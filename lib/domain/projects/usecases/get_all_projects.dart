import 'package:dartz/dartz.dart';
import '../entities/project.dart';
import '../repository/project_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';

class GetAllProjects implements UseCase<List<Project>, NoParams> {
  final ProjectRepository repository;

  GetAllProjects(this.repository);

  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) async {
    return await repository.getAllProjects();
  }
}
