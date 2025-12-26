class ApiConfig {
  // API base URL configuration
  // - For Android Emulator: use 'http://10.0.2.2:8100' (maps to host's localhost)
  // - For iOS Simulator: use 'http://localhost:8100'
  // - For Physical Device: use 'http://<YOUR_COMPUTER_IP>:8100' (e.g., 'http://192.168.1.100:8100')
  // - For Production: use your production server URL
  static const String baseUrl = 'http://10.0.2.2:8100';
  
  // API endpoints
  static const String registerEndpoint = '/api/v1/auth/register';
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String refreshTokenEndpoint = '/api/v1/auth/refresh';
  static const String activateEndpoint = '/api/v1/auth/activate'; // /{token}
  static const String verifyActivationTokenEndpoint = '/api/v1/auth/verify-activation-token';
  static const String resendActivationLinkEndpoint = '/api/v1/auth/resend-activation-link';
  static const String checkActivationStatusEndpoint = '/api/v1/auth/check-activation-status';
  
  // Booking endpoints
  static const String bookingsEndpoint = '/api/v1/bookings';
  static String bookingByIdEndpoint(int id) => '/api/v1/bookings/$id';
  static String cancelBookingEndpoint(int id) => '/api/v1/bookings/$id/cancel';
  
  // Chatbot endpoints
  static const String chatbotSendEndpoint = '/api/v1/chatbot/send';
  static const String chatbotHistoryEndpoint = '/api/v1/chatbot/history';
  static String chatbotSessionHistoryEndpoint(String sessionId) => '/api/v1/chatbot/history/$sessionId';
  
  // Article endpoints
  static const String articlesEndpoint = '/api/v1/articles';
  static String articleByIdEndpoint(int id) => '/api/v1/articles/$id';
  static String articleBySlugEndpoint(String slug) => '/api/v1/articles/slug/$slug';
  static const String articlesSearchEndpoint = '/api/v1/articles/search';
  
  // Notification endpoints
  static const String notificationsMyEndpoint = '/api/v1/notifications/my';
  static const String notificationsUnreadCountEndpoint = '/api/v1/notifications/unread-count';
  static String notificationByIdEndpoint(int id) => '/api/v1/notifications/$id';
  static String notificationMarkReadEndpoint(int id) => '/api/v1/notifications/$id/read';
  static const String notificationsMarkAllReadEndpoint = '/api/v1/notifications/mark-all-read';
  static const String notificationsMarkEndpoint = '/api/v1/notifications/mark';
  static String notificationDeleteEndpoint(int id) => '/api/v1/notifications/$id';
  static const String notificationsDeleteReadEndpoint = '/api/v1/notifications/read';
  static const String notificationsSearchEndpoint = '/api/v1/notifications/search';
  static const String notificationsRecentEndpoint = '/api/v1/notifications/recent';
  static const String notificationsStatsEndpoint = '/api/v1/notifications/stats';
}

