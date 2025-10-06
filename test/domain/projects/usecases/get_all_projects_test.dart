import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:csr_crm/domain/projects/entities/project.dart';
import 'package:csr_crm/domain/projects/repository/project_repository.dart';
import 'package:csr_crm/domain/projects/usecases/get_all_projects.dart';
import 'package:csr_crm/core/error/failures.dart';
import 'package:csr_crm/core/usecases/usecase.dart';

import 'get_all_projects_test.mocks.dart';

@GenerateMocks([ProjectRepository])
void main() {
  late GetAllProjects usecase;
  late MockProjectRepository mockProjectRepository;

  setUp(() {
    mockProjectRepository = MockProjectRepository();
    usecase = GetAllProjects(mockProjectRepository);
  });

  group('GetAllProjects', () {
    final tProjectList = [
      Project(
        id: '1',
        title: 'Test Project 1',
        description: 'Test Description 1',
        budget: 10000.0,
        status: ProjectStatus.active,
        sector: 'Education',
        timeline: ProjectTimeline(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 12, 31),
        ),
      ),
      Project(
        id: '2',
        title: 'Test Project 2',
        description: 'Test Description 2',
        budget: 20000.0,
        status: ProjectStatus.completed,
        sector: 'Healthcare',
        timeline: ProjectTimeline(
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 11, 30),
        ),
      ),
    ];

    test('should get list of projects from the repository', () async {
      // arrange
      when(mockProjectRepository.getAllProjects())
          .thenAnswer((_) async => Right(tProjectList));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(tProjectList));
      verify(mockProjectRepository.getAllProjects());
      verifyNoMoreInteractions(mockProjectRepository);
    });

    test('should return server failure when the call to repository is unsuccessful', () async {
      // arrange
      when(mockProjectRepository.getAllProjects())
          .thenAnswer((_) async => Left(ServerFailure()));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Left(ServerFailure()));
      verify(mockProjectRepository.getAllProjects());
      verifyNoMoreInteractions(mockProjectRepository);
    });
  });
}
