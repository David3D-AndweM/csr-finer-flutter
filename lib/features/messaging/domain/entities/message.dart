import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String receiverId;
  final String? receiverName;
  final String? projectId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final List<MessageAttachment> attachments;
  final String? replyToId;
  final MessageStatus status;

  const Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.receiverId,
    this.receiverName,
    this.projectId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.attachments = const [],
    this.replyToId,
    this.status = MessageStatus.sent,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderRole,
    String? receiverId,
    String? receiverName,
    String? projectId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isRead,
    List<MessageAttachment>? attachments,
    String? replyToId,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      projectId: projectId ?? this.projectId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      attachments: attachments ?? this.attachments,
      replyToId: replyToId ?? this.replyToId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        senderId,
        senderName,
        senderRole,
        receiverId,
        receiverName,
        projectId,
        content,
        type,
        timestamp,
        isRead,
        attachments,
        replyToId,
        status,
      ];
}

class MessageAttachment extends Equatable {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final DateTime uploadedAt;

  const MessageAttachment({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
  });

  @override
  List<Object> get props => [
        id,
        fileName,
        fileUrl,
        fileType,
        fileSize,
        uploadedAt,
      ];
}

enum MessageType {
  text,
  file,
  image,
  system,
  milestone,
  survey,
  budget,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class Conversation extends Equatable {
  final String id;
  final String? projectId;
  final String? projectName;
  final List<String> participantIds;
  final List<ConversationParticipant> participants;
  final Message? lastMessage;
  final DateTime lastActivity;
  final int unreadCount;
  final ConversationType type;
  final String? title;

  const Conversation({
    required this.id,
    this.projectId,
    this.projectName,
    required this.participantIds,
    required this.participants,
    this.lastMessage,
    required this.lastActivity,
    this.unreadCount = 0,
    required this.type,
    this.title,
  });

  Conversation copyWith({
    String? id,
    String? projectId,
    String? projectName,
    List<String>? participantIds,
    List<ConversationParticipant>? participants,
    Message? lastMessage,
    DateTime? lastActivity,
    int? unreadCount,
    ConversationType? type,
    String? title,
  }) {
    return Conversation(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastActivity: lastActivity ?? this.lastActivity,
      unreadCount: unreadCount ?? this.unreadCount,
      type: type ?? this.type,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        projectName,
        participantIds,
        participants,
        lastMessage,
        lastActivity,
        unreadCount,
        type,
        title,
      ];
}

class ConversationParticipant extends Equatable {
  final String userId;
  final String name;
  final String role;
  final String? avatar;
  final bool isOnline;
  final DateTime? lastSeen;

  const ConversationParticipant({
    required this.userId,
    required this.name,
    required this.role,
    this.avatar,
    this.isOnline = false,
    this.lastSeen,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        role,
        avatar,
        isOnline,
        lastSeen,
      ];
}

enum ConversationType {
  direct,
  project,
  group,
}
