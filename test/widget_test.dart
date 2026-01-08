// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:daily_dose_of_happiness/main.dart';
import 'package:daily_dose_of_happiness/service/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakePushNotificationService implements PushNotificationClient {
  PushNotificationPreference _preference = PushNotificationPreference.empty;

  @override
  Future<PushNotificationPreference> fetchPreference() async {
    return _preference;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<PushNotificationPreference> setEnabled(bool enabled) async {
    _preference = _preference.copyWith(enabled: enabled);
    return _preference;
  }

  @override
  Future<PushNotificationPreference> updateDeliveryTime(TimeOfDay timeOfDay) async {
    _preference = _preference.copyWith(deliveryTime: timeOfDay);
    return _preference;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'supabase-anon-key',
    );
  });

  testWidgets('renders application root without crashing', (tester) async {
    final pushService = _FakePushNotificationService();
    await tester.pumpWidget(MyApp(pushService: pushService));

    expect(find.byType(MyApp), findsOneWidget);
  });
}
