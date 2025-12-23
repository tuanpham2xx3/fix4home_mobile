import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/api_client.dart';
import 'api_conversation_repository.dart';
import 'api_message_repository.dart';

final conversationRepositoryProvider = Provider<ApiConversationRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ApiConversationRepository(dio);
});

final messageRepositoryProvider = Provider<ApiMessageRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ApiMessageRepository(dio);
});

