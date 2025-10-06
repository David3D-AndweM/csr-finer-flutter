import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/messaging_repository.dart';

class GetMessages implements UseCase<List<Message>, GetMessagesParams> {
  final MessagingRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesParams params) async {
    return await repository.getMessages(
      conversationId: params.conversationId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetMessagesParams {
  final String conversationId;
  final int page;
  final int limit;

  GetMessagesParams({
    required this.conversationId,
    this.page = 1,
    this.limit = 50,
  });
}

class GetMessagesStream implements StreamUseCase<List<Message>, GetMessagesStreamParams> {
  final MessagingRepository repository;

  GetMessagesStream(this.repository);

  @override
  Stream<List<Message>> call(GetMessagesStreamParams params) {
    return repository.getMessagesStream(params.conversationId);
  }
}

class GetMessagesStreamParams {
  final String conversationId;

  GetMessagesStreamParams({required this.conversationId});
}
