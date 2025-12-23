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

  // Chat & message endpoints
  static const String conversationsEndpoint = '/api/v1/chat/conversations';
  static const String conversationsPaginatedEndpoint =
      '/api/v1/chat/conversations/paginated';
  static String conversationByIdEndpoint(int id) =>
      '/api/v1/chat/conversations/$id';
  static const String findOrCreateConversationEndpoint =
      '/api/v1/chat/conversations/find-or-create';
  static String archiveConversationEndpoint(int id) =>
      '/api/v1/chat/conversations/$id/archive';

  static String messagesEndpoint(int conversationId) =>
      '/api/v1/chat/conversations/$conversationId/messages';
  static String messagesBeforeEndpoint(int conversationId) =>
      '/api/v1/chat/conversations/$conversationId/messages/before';
  static const String markMessagesReadEndpoint =
      '/api/v1/chat/messages/mark-read';
  static const String unreadMessagesEndpoint =
      '/api/v1/chat/messages/unread';

  // Chatbot endpoint
  static const String chatbotSendEndpoint = '/api/v1/chatbot/send';

  // WebSocket
  static const String webSocketPathNative = '/ws-native';
  
  /// Get WebSocket URL for native clients
  static String getWebSocketUrl() {
    // Convert http:// to ws://
    final wsBaseUrl = baseUrl.replaceFirst('http://', 'ws://');
    return '$wsBaseUrl$webSocketPathNative';
  }
}

