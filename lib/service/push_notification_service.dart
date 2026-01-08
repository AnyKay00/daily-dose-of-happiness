import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const AndroidNotificationChannel _defaultAndroidChannel = AndroidNotificationChannel(
  'daily_dose_general',
  'Daily Dose Notifications',
  description: 'All reminders sent from Daily Dose of Happiness.',
  importance: Importance.high,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotificationPreference {
  final bool enabled;
  final TimeOfDay? deliveryTime;

  const PushNotificationPreference({required this.enabled, this.deliveryTime});

  static const empty = PushNotificationPreference(enabled: false);

  PushNotificationPreference copyWith({bool? enabled, TimeOfDay? deliveryTime}) {
    return PushNotificationPreference(
      enabled: enabled ?? this.enabled,
      deliveryTime: deliveryTime ?? this.deliveryTime,
    );
  }

  factory PushNotificationPreference.fromJson(Map<String, dynamic>? json) {
    if (json == null) return empty;
    final hour = json['daily_push_hour'];
    final minute = json['daily_push_minute'];
    TimeOfDay? time;
    if (hour is num && minute is num) {
      time = TimeOfDay(hour: hour.toInt(), minute: minute.toInt());
    }
    return PushNotificationPreference(
      enabled: json['daily_push_enabled'] == true,
      deliveryTime: time,
    );
  }

  Map<String, dynamic> toUpdatePayload(String userId) {
    return {
      'user_id': userId,
      'daily_push_enabled': enabled,
      'daily_push_hour': deliveryTime?.hour,
      'daily_push_minute': deliveryTime?.minute,
    };
  }
}

abstract class PushNotificationClient {
  Future<void> initialize();
  Future<PushNotificationPreference> fetchPreference();
  Future<PushNotificationPreference> setEnabled(bool enabled);
  Future<PushNotificationPreference> updateDeliveryTime(TimeOfDay timeOfDay);
}

class PushNotificationService implements PushNotificationClient {
  PushNotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    SupabaseClient? supabase,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin(),
        _supabase = supabase ?? Supabase.instance.client;

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final SupabaseClient _supabase;

  bool _initialized = false;
  bool _permissionGranted = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/app_logo'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(initializationSettings);
    await _ensureAndroidChannel();

    final settings = await _messaging.requestPermission();
    _permissionGranted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (_permissionGranted) {
      await _persistCurrentToken();
      _messaging.onTokenRefresh.listen(_persistToken);
    }

    FirebaseMessaging.onMessage.listen(_displayForegroundNotification);
  }

  Future<void> _ensureAndroidChannel() async {
    final androidImpl = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(_defaultAndroidChannel);
  }

  void _displayForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _defaultAndroidChannel.id,
        _defaultAndroidChannel.name,
        channelDescription: _defaultAndroidChannel.description,
        priority: Priority.high,
        importance: Importance.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.isEmpty ? null : jsonEncode(message.data),
    );
  }

  @override
  Future<PushNotificationPreference> fetchPreference() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return PushNotificationPreference.empty;

    try {
      final response = await _supabase
          .from('user_profile')
          .select('daily_push_enabled,daily_push_hour,daily_push_minute')
          .eq('user_id', uid)
          .maybeSingle();
      return PushNotificationPreference.fromJson(response);
    } catch (_) {
      return PushNotificationPreference.empty;
    }
  }

  Future<void> _persistCurrentToken() async {
    final token = await _messaging.getToken();
    await _persistToken(token);
  }

  Future<void> _persistToken(String? token) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    await _supabase.from('user_profile').upsert({
      'user_id': uid,
      'push_token': token,
    }, onConflict: 'user_id');
  }

  @override
  Future<PushNotificationPreference> setEnabled(bool enabled) async {
    final current = await fetchPreference();
    return _upsertPreference(current.copyWith(enabled: enabled));
  }

  @override
  Future<PushNotificationPreference> updateDeliveryTime(TimeOfDay timeOfDay) async {
    final current = await fetchPreference();
    return _upsertPreference(current.copyWith(deliveryTime: timeOfDay));
  }

  Future<PushNotificationPreference> _upsertPreference(
      PushNotificationPreference preference) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      throw Exception('No authenticated user for notification preferences');
    }

    try {
      final payload = preference.toUpdatePayload(uid);
      final response = await _supabase
          .from('user_profile')
          .upsert(payload, onConflict: 'user_id')
          .select('daily_push_enabled,daily_push_hour,daily_push_minute')
          .single();

      if (preference.enabled && _permissionGranted) {
        await _persistCurrentToken();
      } else if (!preference.enabled) {
        await _persistToken(null);
      }

      return PushNotificationPreference.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update notification preference: $error');
    }
  }
}
