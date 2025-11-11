class ApiConfig {
  // TODO: Replace with actual API base URL
  // You can use environment variables or different URLs for dev/prod
  static const String baseUrl = 'http://10.0.2.2:8100';
  
  // API endpoints
  static const String registerEndpoint = '/api/v1/auth/register';
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String refreshTokenEndpoint = '/api/v1/auth/refresh';
}

