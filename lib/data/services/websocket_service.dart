import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../../domain/models/chat_api_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService();
});

class WebSocketService {
  StompClient? _stompClient;
  bool _isConnected = false;
  Function(MessageDTO message)? _onMessageReceived;
  Function(Map<String, dynamic> status)? _onReadStatusUpdate;

  WebSocketService();

  /// Set callback for received messages
  void setOnMessageReceived(Function(MessageDTO message) callback) {
    _onMessageReceived = callback;
  }

  /// Set callback for read status updates
  void setOnReadStatusUpdate(Function(Map<String, dynamic> status) callback) {
    _onReadStatusUpdate = callback;
  }

  /// Connect to WebSocket server
  Future<void> connect(String wsUrl, String jwtToken) async {
    _stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: _onConnect,
        onStompError: _onError,
        reconnectDelay: const Duration(seconds: 5),
        connectionTimeout: const Duration(seconds: 10),
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 300));
        },
      ),
    );

    _stompClient!.activate();
  }

  void _onConnect(StompFrame frame) {
    _isConnected = true;
    _subscribeToMessages();
  }

  void _onError(StompFrame frame) {
    _isConnected = false;
    // Error handling - could emit to a stream or callback
  }

  /// Subscribe to receive messages
  void _subscribeToMessages() {
    if (_stompClient == null || !_isConnected) {
      return;
    }

    // Subscribe to user-specific messages
    _stompClient!.subscribe(
      destination: '/user/queue/messages',
      callback: (frame) {
        try {
          if (frame.body != null) {
            final messageJson = jsonDecode(frame.body!);
            final message = MessageDTO.fromJson(messageJson as Map<String, dynamic>);
            _onMessageReceived?.call(message);
          }
        } catch (e) {
          // Error parsing message - could log to error service
        }
      },
    );

    // Subscribe to read status updates
    _stompClient!.subscribe(
      destination: '/user/queue/read-status',
      callback: (frame) {
        try {
          if (frame.body != null) {
            final statusJson = jsonDecode(frame.body!) as Map<String, dynamic>;
            _onReadStatusUpdate?.call(statusJson);
          }
        } catch (e) {
          // Error parsing read status - could log to error service
        }
      },
    );
  }

  /// Send message via WebSocket
  void sendMessage({
    required int conversationId,
    required String content,
  }) {
    if (_stompClient == null || !_isConnected) {
      throw Exception('WebSocket is not connected');
    }

    _stompClient!.send(
      destination: '/app/chat.send',
      body: jsonEncode({
        'conversationId': conversationId,
        'content': content,
        'messageType': 'TEXT',
      }),
    );
  }

  /// Send typing indicator
  void sendTypingIndicator({
    required int conversationId,
  }) {
    if (_stompClient == null || !_isConnected) {
      return; // Silent fail for typing indicator
    }

    _stompClient!.send(
      destination: '/app/chat.typing',
      body: jsonEncode({
        'conversationId': conversationId,
      }),
    );
  }

  /// Subscribe to typing indicators for a conversation
  void subscribeToTypingIndicator(
    int conversationId,
    Function(Map<String, dynamic>) callback,
  ) {
    if (_stompClient == null || !_isConnected) {
      return;
    }

    _stompClient!.subscribe(
      destination: '/topic/conversation/$conversationId/typing',
      callback: (frame) {
        try {
          if (frame.body != null) {
            final indicator = jsonDecode(frame.body!) as Map<String, dynamic>;
            callback(indicator);
          }
        } catch (e) {
          // Error parsing typing indicator - could log to error service
        }
      },
    );
  }

  /// Check if WebSocket is connected
  bool get isConnected => _isConnected && _stompClient != null;

  /// Disconnect from WebSocket
  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
    _isConnected = false;
  }

  /// Reconnect with new token if needed
  Future<void> reconnect(String wsUrl, String jwtToken) async {
    disconnect();
    await connect(wsUrl, jwtToken);
  }
}

