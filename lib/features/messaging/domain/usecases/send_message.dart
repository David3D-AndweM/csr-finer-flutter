import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/messaging_repository.dart';

class SendMessage implements UseCase<Message, SendMessageParams> {
  final MessagingRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      conversationId: params.conversationId,
      content: params.content,
      type: params.type,
      replyToId: params.replyToId,
      attachmentPaths: params.attachmentPaths,
    );
  }
}

class SendMessageParams {
  final String conversationId;
  final String content;
  final MessageType type;
  final String? replyToId;
  final List<String>? attachmentPaths;

  SendMessageParams({
    required this.conversationId,
    required this.content,
    required this.type,
    this.replyToId,
    this.attachmentPaths,
  });
}
