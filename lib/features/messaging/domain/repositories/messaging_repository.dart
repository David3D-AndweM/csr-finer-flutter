import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';

abstract class MessagingRepository {
  // Real-time messaging
  Stream<List<Message>> getMessagesStream(String conversationId);
  Stream<List<Conversation>> getConversationsStream(String userId);
  Stream<int> getUnreadCountStream(String userId);
  
  // Message operations
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String content,
    required MessageType type,
    String? replyToId,
    List<String>? attachmentPaths,
  });
  
  Future<Either<Failure, List<Message>>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  });
  
  Future<Either<Failure, void>> markMessageAsRead(String messageId);
  Future<Either<Failure, void>> markConversationAsRead(String conversationId);
  
  // Conversation operations
  Future<Either<Failure, List<Conversation>>> getConversations(String userId);
  
  Future<Either<Failure, Conversation>> createConversation({
    required List<String> participantIds,
    String? projectId,
    ConversationType type = ConversationType.direct,
    String? title,
  });
  
  Future<Either<Failure, Conversation>> getOrCreateProjectConversation({
    required String projectId,
    required List<String> participantIds,
  });
  
  Future<Either<Failure, Conversation>> getConversation(String conversationId);
  
  // File operations
  Future<Either<Failure, String>> uploadAttachment({
    required String filePath,
    required String conversationId,
  });
  
  // Notification operations
  Future<Either<Failure, void>> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
  
  // Online status
  Future<Either<Failure, void>> updateOnlineStatus(bool isOnline);
  Stream<Map<String, bool>> getOnlineStatusStream(List<String> userIds);
  
  // Search
  Future<Either<Failure, List<Message>>> searchMessages({
    required String query,
    String? conversationId,
    String? userId,
  });
}
