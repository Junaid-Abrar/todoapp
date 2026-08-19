import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/utils/date_utils.dart';

void main() {
  group('AppDateUtils.formatDate', () {
    test('labels relative days', () {
      final now = DateTime.now();
      expect(AppDateUtils.formatDate(now), 'Today');
      expect(
        AppDateUtils.formatDate(now.subtract(const Duration(days: 1))),
        'Yesterday',
      );
      expect(
        AppDateUtils.formatDate(now.add(const Duration(days: 1))),
        'Tomorrow',
      );
    });
  });

  group('AppDateUtils.isToday', () {
    test('ignores the time component', () {
      final now = DateTime.now();
      final sameDayDifferentTime =
          DateTime(now.year, now.month, now.day, 23, 59);
      expect(AppDateUtils.isToday(sameDayDifferentTime), isTrue);
    });
  });

  group('AppDateUtils.daysBetween', () {
    test('counts calendar days, not elapsed hours', () {
      final start = DateTime(2026, 1, 1, 23, 0);
      final end = DateTime(2026, 1, 2, 1, 0);
      expect(AppDateUtils.daysBetween(start, end), 1);
    });
  });

  group('AppDateUtils.getWeekDates', () {
    test('returns seven days starting on Monday', () {
      final week = AppDateUtils.getWeekDates(DateTime(2026, 8, 19));
      expect(week, hasLength(7));
      expect(week.first.weekday, DateTime.monday);
      expect(week.last.weekday, DateTime.sunday);
    });
  });
}
