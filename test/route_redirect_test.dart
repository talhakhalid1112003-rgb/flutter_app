import 'package:flutter_test/flutter_test.dart';
import 'package:scoring_app/core/routes/app_router.dart';

void main() {
  group('redirectForAuth', () {
    test('allows public auth routes for signed-out users', () {
      expect(redirectForAuth('/login', false), isNull);
      expect(redirectForAuth('/signup', false), isNull);
      expect(redirectForAuth('/forgot-password', false), isNull);
      expect(redirectForAuth('/reset-password-success', false), isNull);
    });

    test('redirects signed-out users away from private routes', () {
      expect(redirectForAuth('/sport-selection', false), '/login');
      expect(redirectForAuth('/dashboard/badminton', false), '/login');
    });

    test('redirects signed-in users away from auth routes', () {
      expect(redirectForAuth('/login', true), '/sport-selection');
      expect(redirectForAuth('/signup', true), '/sport-selection');
      expect(redirectForAuth('/', true), '/sport-selection');
      expect(redirectForAuth('/forgot-password', true), isNull);
    });
  });
}