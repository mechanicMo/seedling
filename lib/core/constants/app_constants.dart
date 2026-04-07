class AppConstants {
  // Firestore collection names
  static const String usersCollection = 'users';
  static const String childrenCollection = 'children';
  static const String sessionsCollection = 'sessions';
  static const String chatSessionsCollection = 'chat_sessions';
  static const String parentGuidesCollection = 'parent_guides';
  static const String childActivitiesCollection = 'child_activities';

  // Freemium limits
  static const int freeAiQueriesPerDay = 20;
  static const int freeSessionReportsPerMonth = 10;
  static const int freeChildProfileLimit = 3;

  // Session timer defaults
  static const int defaultSessionTimerMinutes = 20;
  static const int sessionTimerWarningMinutes = 2;

  // Age ranges
  static const String ageRange0to3 = '0-3';
  static const String ageRange3to7 = '3-7';
  static const String ageRange7to12 = '7-12';

  // Content categories
  static const List<String> allCategories = [
    'behavior', 'development', 'sleep', 'emotions',
    'routines', 'feeding', 'transitions', 'relationships',
  ];

  static const List<String> parentGuideCategories = [
    'behavior', 'sleep', 'emotions', 'development', 'routines',
  ];

  // Activity types
  static const List<String> allActivityTypes = [
    'story', 'game', 'music', 'movement', 'video', 'creative',
  ];

  // v1 activity types (subset available at launch)
  static const List<String> v1ActivityTypes = ['story', 'game', 'music'];
}
