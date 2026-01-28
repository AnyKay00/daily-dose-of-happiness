import 'package:daily_dose_of_happiness/service/push_notification_service.dart';
import 'package:flutter/material.dart';

class PushNotificationController extends ChangeNotifier {
  PushNotificationController({required PushNotificationClient service})
      : _service = service;

  final PushNotificationClient _service;

  bool _initialized = false;
  bool _loading = false;
  PushNotificationPreference _preference = PushNotificationPreference.empty;
  String? _error;

  bool get loading => _loading;
  bool get isInitialized => _initialized;
  bool get enabled => _preference.enabled;
  String? get error => _error;

  Future<void> bootstrap() async {
    if (_initialized) return;
    await _service.initialize();
    await refresh();
    _initialized = true;
  }

  Future<void> refresh() async {
    _error = null;
    _loading = true;
    notifyListeners();
    try {
      _preference = await _service.fetchPreference();
      print(_preference.enabled);
    } catch (error) {
      _error = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> setEnabled(bool enabled) async {
    _error = null;
    _loading = true;
    notifyListeners();
    try {
      print('bool');
      print(enabled);
      _preference = await _service.setEnabled(enabled);
      print(_preference.enabled);
    } catch (error) {
      _error = error.toString();
      print(_error);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
