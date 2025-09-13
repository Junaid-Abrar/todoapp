import 'package:flutter/material.dart';

class AppConstants {
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Border radius
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius20 = 20.0;
  static const double borderRadius24 = 24.0;

  // Icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 48.0;

  // Categories
  static const List<String> todoCategories = [
    'Work',
    'Personal',
    'Health',
    'Education',
    'Shopping',
    'Travel',
    'Finance',
    'Entertainment',
  ];

  // Priority levels
  static const List<String> priorityLevels = [
    'Low',
    'Medium',
    'High',
  ];

  // Default values
  static const String defaultCategory = 'Personal';
  static const String defaultPriority = 'Medium';
  
  // Validation
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int minTitleLength = 1;
  
  // UI messages
  static const String emptyTodosMessage = 'No todos yet.\nTap + to create your first task!';
  static const String completedTodosMessage = 'Great job! All tasks completed.';
  static const String errorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'No internet connection. Please check your network.';
  
  // Feature flags
  static const bool enableNotifications = true;
  static const bool enableAnalytics = false;
  static const bool enableDarkMode = true;
}

class CategoryIcons {
  static const Map<String, IconData> categoryIcons = {
    'Work': Icons.work_outline,
    'Personal': Icons.person_outline,
    'Health': Icons.favorite_outline,
    'Education': Icons.school_outlined,
    'Shopping': Icons.shopping_bag_outlined,
    'Travel': Icons.flight_outlined,
    'Finance': Icons.account_balance_wallet_outlined,
    'Entertainment': Icons.movie_outlined,
  };

  static IconData getIcon(String category) {
    return categoryIcons[category] ?? Icons.task_outlined;
  }
}

class PriorityIcons {
  static const Map<String, IconData> priorityIcons = {
    'Low': Icons.keyboard_arrow_down,
    'Medium': Icons.remove,
    'High': Icons.keyboard_arrow_up,
  };

  static IconData getIcon(String priority) {
    return priorityIcons[priority] ?? Icons.remove;
  }
}