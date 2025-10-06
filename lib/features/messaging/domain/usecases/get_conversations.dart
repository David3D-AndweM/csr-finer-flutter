import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/messaging_repository.dart';

class GetConversations implements UseCase<List<Conversation>, GetConversationsParams> {
  final MessagingRepository repository;

  GetConversations(this.repository);

  @override
  Future<Either<Failure, List<Conversation>>> call(GetConversationsParams params) async {
    return await repository.getConversations(params.userId);
  }
}

class GetConversationsParams {
  final String userId;

  GetConversationsParams({required this.userId});
}

class GetConversationsStream implements StreamUseCase<List<Conversation>, GetConversationsParams> {
  final MessagingRepository repository;

  GetConversationsStream(this.repository);

  @override
  Stream<List<Conversation>> call(GetConversationsParams params) {
    return repository.getConversationsStream(params.userId);
  }
}
