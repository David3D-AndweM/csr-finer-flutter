import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/message_model.dart';

abstract class MessagingRemoteDataSource {
  Stream<List<MessageModel>> getMessagesStream(String conversationId);
  Stream<List<ConversationModel>> getConversationsStream(String userId);
  Stream<int> getUnreadCountStream(String userId);
  
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    required String type,
    String? replyToId,
    List<String>? attachmentPaths,
  });
  
  Future<List<MessageModel>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  });
  
  Future<void> markMessageAsRead(String messageId);
  Future<void> markConversationAsRead(String conversationId);
  
  Future<List<ConversationModel>> getConversations(String userId);
  
  Future<ConversationModel> createConversation({
    required List<String> participantIds,
    String? projectId,
    String type = 'direct',
    String? title,
  });
  
  Future<ConversationModel> getOrCreateProjectConversation({
    required String projectId,
    required List<String> participantIds,
  });
  
  Future<ConversationModel> getConversation(String conversationId);
  
  Future<String> uploadAttachment({
    required String filePath,
    required String conversationId,
  });
  
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
  
  Future<void> updateOnlineStatus(bool isOnline);
  Stream<Map<String, bool>> getOnlineStatusStream(List<String> userIds);
  
  Future<List<MessageModel>> searchMessages({
    required String query,
    String? conversationId,
    String? userId,
  });
}

class MessagingRemoteDataSourceImpl implements MessagingRemoteDataSource {
  final DioClient dioClient;
  WebSocketChannel? _webSocketChannel;
  final Map<String, StreamController<List<MessageModel>>> _messageStreams = {};
  final Map<String, StreamController<List<ConversationModel>>> _conversationStreams = {};
  final Map<String, StreamController<int>> _unreadCountStreams = {};
  final StreamController<Map<String, bool>> _onlineStatusController = StreamController.broadcast();
  
  MessagingRemoteDataSourceImpl({required this.dioClient});

  void _initializeWebSocket() {
    if (_webSocketChannel != null) return;
    
    try {
      _webSocketChannel = WebSocketChannel.connect(
        Uri.parse('${ApiConstants.wsBaseUrl}/messaging'),
      );
      
      _webSocketChannel!.stream.listen(
        (data) {
          _handleWebSocketMessage(data);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _reconnectWebSocket();
        },
        onDone: () {
          print('WebSocket connection closed');
          _reconnectWebSocket();
        },
      );
    } catch (e) {
      print('Failed to initialize WebSocket: $e');
    }
  }
  
  void _handleWebSocketMessage(dynamic data) {
    try {
      final Map<String, dynamic> message = jsonDecode(data);
      final String type = message['type'];
      
      switch (type) {
        case 'new_message':
          _handleNewMessage(message['data']);
          break;
        case 'message_read':
          _handleMessageRead(message['data']);
          break;
        case 'conversation_updated':
          _handleConversationUpdated(message['data']);
          break;
        case 'online_status':
          _handleOnlineStatus(message['data']);
          break;
        case 'unread_count':
          _handleUnreadCount(message['data']);
          break;
      }
    } catch (e) {
      print('Error handling WebSocket message: $e');
    }
  }
  
  void _handleNewMessage(Map<String, dynamic> data) {
    final message = MessageModel.fromJson(data['message']);
    final conversationId = data['conversationId'] as String;
    
    if (_messageStreams.containsKey(conversationId)) {
      // Add new message to existing stream
      // This would typically involve updating the current list
    }
  }
  
  void _handleMessageRead(Map<String, dynamic> data) {
    // Handle message read status updates
  }
  
  void _handleConversationUpdated(Map<String, dynamic> data) {
    // Handle conversation updates
  }
  
  void _handleOnlineStatus(Map<String, dynamic> data) {
    final status = Map<String, bool>.from(data);
    _onlineStatusController.add(status);
  }
  
  void _handleUnreadCount(Map<String, dynamic> data) {
    final userId = data['userId'] as String;
    final count = data['count'] as int;
    
    if (_unreadCountStreams.containsKey(userId)) {
      _unreadCountStreams[userId]!.add(count);
    }
  }
  
  void _reconnectWebSocket() {
    _webSocketChannel = null;
    Timer(const Duration(seconds: 5), () {
      _initializeWebSocket();
    });
  }

  @override
  Stream<List<MessageModel>> getMessagesStream(String conversationId) {
    _initializeWebSocket();
    
    if (!_messageStreams.containsKey(conversationId)) {
      _messageStreams[conversationId] = StreamController<List<MessageModel>>.broadcast();
      
      // Subscribe to conversation messages via WebSocket
      _webSocketChannel?.sink.add(jsonEncode({
        'type': 'subscribe_messages',
        'conversationId': conversationId,
      }));
    }
    
    return _messageStreams[conversationId]!.stream;
  }

  @override
  Stream<List<ConversationModel>> getConversationsStream(String userId) {
    _initializeWebSocket();
    
    if (!_conversationStreams.containsKey(userId)) {
      _conversationStreams[userId] = StreamController<List<ConversationModel>>.broadcast();
      
      // Subscribe to user conversations via WebSocket
      _webSocketChannel?.sink.add(jsonEncode({
        'type': 'subscribe_conversations',
        'userId': userId,
      }));
    }
    
    return _conversationStreams[userId]!.stream;
  }

  @override
  Stream<int> getUnreadCountStream(String userId) {
    _initializeWebSocket();
    
    if (!_unreadCountStreams.containsKey(userId)) {
      _unreadCountStreams[userId] = StreamController<int>.broadcast();
      
      // Subscribe to unread count via WebSocket
      _webSocketChannel?.sink.add(jsonEncode({
        'type': 'subscribe_unread_count',
        'userId': userId,
      }));
    }
    
    return _unreadCountStreams[userId]!.stream;
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    required String type,
    String? replyToId,
    List<String>? attachmentPaths,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.sendMessage,
        data: {
          'conversationId': conversationId,
          'content': content,
          'type': type,
          'replyToId': replyToId,
          'attachmentPaths': attachmentPaths,
        },
      );
      
      return MessageModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to send message');
    }
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.getMessages}/$conversationId',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      
      final List<dynamic> messagesJson = response.data['data']['messages'];
      return messagesJson.map((json) => MessageModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to get messages');
    }
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await dioClient.patch(
        '${ApiConstants.markMessageRead}/$messageId',
      );
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to mark message as read');
    }
  }

  @override
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      await dioClient.patch(
        '${ApiConstants.markConversationRead}/$conversationId',
      );
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to mark conversation as read');
    }
  }

  @override
  Future<List<ConversationModel>> getConversations(String userId) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.getConversations}/$userId',
      );
      
      final List<dynamic> conversationsJson = response.data['data'];
      return conversationsJson.map((json) => ConversationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to get conversations');
    }
  }

  @override
  Future<ConversationModel> createConversation({
    required List<String> participantIds,
    String? projectId,
    String type = 'direct',
    String? title,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.createConversation,
        data: {
          'participantIds': participantIds,
          'projectId': projectId,
          'type': type,
          'title': title,
        },
      );
      
      return ConversationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to create conversation');
    }
  }

  @override
  Future<ConversationModel> getOrCreateProjectConversation({
    required String projectId,
    required List<String> participantIds,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.getOrCreateProjectConversation,
        data: {
          'projectId': projectId,
          'participantIds': participantIds,
        },
      );
      
      return ConversationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to get or create project conversation');
    }
  }

  @override
  Future<ConversationModel> getConversation(String conversationId) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.getConversation}/$conversationId',
      );
      
      return ConversationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to get conversation');
    }
  }

  @override
  Future<String> uploadAttachment({
    required String filePath,
    required String conversationId,
  }) async {
    try {
      final file = File(filePath);
      final fileName = file.path.split('/').last;
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'conversationId': conversationId,
      });
      
      final response = await dioClient.post(
        ApiConstants.uploadAttachment,
        data: formData,
      );
      
      return response.data['data']['fileUrl'];
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to upload attachment');
    }
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      await dioClient.post(
        ApiConstants.sendNotification,
        data: {
          'userId': userId,
          'title': title,
          'body': body,
          'data': data,
        },
      );
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to send notification');
    }
  }

  @override
  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      await dioClient.patch(
        ApiConstants.updateOnlineStatus,
        data: {'isOnline': isOnline},
      );
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to update online status');
    }
  }

  @override
  Stream<Map<String, bool>> getOnlineStatusStream(List<String> userIds) {
    _initializeWebSocket();
    
    // Subscribe to online status updates
    _webSocketChannel?.sink.add(jsonEncode({
      'type': 'subscribe_online_status',
      'userIds': userIds,
    }));
    
    return _onlineStatusController.stream;
  }

  @override
  Future<List<MessageModel>> searchMessages({
    required String query,
    String? conversationId,
    String? userId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiConstants.searchMessages,
        queryParameters: {
          'query': query,
          'conversationId': conversationId,
          'userId': userId,
        },
      );
      
      final List<dynamic> messagesJson = response.data['data'];
      return messagesJson.map((json) => MessageModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to search messages');
    }
  }
  
  void dispose() {
    _webSocketChannel?.sink.close();
    for (final controller in _messageStreams.values) {
      controller.close();
    }
    for (final controller in _conversationStreams.values) {
      controller.close();
    }
    for (final controller in _unreadCountStreams.values) {
      controller.close();
    }
    _onlineStatusController.close();
  }
}
