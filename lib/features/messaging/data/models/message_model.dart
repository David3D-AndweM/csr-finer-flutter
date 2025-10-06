import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.senderRole,
    required super.receiverId,
    super.receiverName,
    super.projectId,
    required super.content,
    required super.type,
    required super.timestamp,
    super.isRead,
    super.attachments,
    super.replyToId,
    super.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderRole: json['senderRole'] as String,
      receiverId: json['receiverId'] as String,
      receiverName: json['receiverName'] as String?,
      projectId: json['projectId'] as String?,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((e) => MessageAttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      replyToId: json['replyToId'] as String?,
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'projectId': projectId,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'attachments': attachments.map((e) => (e as MessageAttachmentModel).toJson()).toList(),
      'replyToId': replyToId,
      'status': status.name,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      senderId: message.senderId,
      senderName: message.senderName,
      senderRole: message.senderRole,
      receiverId: message.receiverId,
      receiverName: message.receiverName,
      projectId: message.projectId,
      content: message.content,
      type: message.type,
      timestamp: message.timestamp,
      isRead: message.isRead,
      attachments: message.attachments,
      replyToId: message.replyToId,
      status: message.status,
    );
  }
}

class MessageAttachmentModel extends MessageAttachment {
  const MessageAttachmentModel({
    required super.id,
    required super.fileName,
    required super.fileUrl,
    required super.fileType,
    required super.fileSize,
    required super.uploadedAt,
  });

  factory MessageAttachmentModel.fromJson(Map<String, dynamic> json) {
    return MessageAttachmentModel(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'fileSize': fileSize,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    super.projectId,
    super.projectName,
    required super.participantIds,
    required super.participants,
    super.lastMessage,
    required super.lastActivity,
    super.unreadCount,
    required super.type,
    super.title,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String?,
      projectName: json['projectName'] as String?,
      participantIds: List<String>.from(json['participantIds'] as List),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => ConversationParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
      type: ConversationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ConversationType.direct,
      ),
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'projectName': projectName,
      'participantIds': participantIds,
      'participants': participants.map((e) => (e as ConversationParticipantModel).toJson()).toList(),
      'lastMessage': lastMessage != null ? (lastMessage! as MessageModel).toJson() : null,
      'lastActivity': lastActivity.toIso8601String(),
      'unreadCount': unreadCount,
      'type': type.name,
      'title': title,
    };
  }
}

class ConversationParticipantModel extends ConversationParticipant {
  const ConversationParticipantModel({
    required super.userId,
    required super.name,
    required super.role,
    super.avatar,
    super.isOnline,
    super.lastSeen,
  });

  factory ConversationParticipantModel.fromJson(Map<String, dynamic> json) {
    return ConversationParticipantModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      avatar: json['avatar'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'role': role,
      'avatar': avatar,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }
}
