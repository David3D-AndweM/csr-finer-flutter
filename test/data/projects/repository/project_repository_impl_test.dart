import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:csr_finer_flutter/core/errors/failures.dart';
import 'package:csr_finer_flutter/domain/entities/project.dart';
import 'package:csr_finer_flutter/data/projects/datasource/project_remote_datasource.dart';
import 'package:csr_finer_flutter/data/projects/models/project_model.dart';
import 'package:csr_finer_flutter/data/projects/repository/project_repository_impl.dart';

import 'project_repository_impl_test.mocks.dart';

@GenerateMocks([ProjectRemoteDataSource])
void main() {
  late ProjectRepositoryImpl repository;
  late MockProjectRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProjectRemoteDataSource();
    repository = ProjectRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tProjectModels = [
    const ProjectModel(
      id: '1',
      projectCode: 'EDU-001',
      title: 'Test Project 1',
      description: 'Test Description 1',
      recipientId: 'REC-001',
      sector: 'education',
      estimatedBudget: 100000.0,
      actualExpenditure: 25000.0,
      startDate: '2024-01-01T00:00:00.000Z',
      endDate: '2024-12-31T23:59:59.000Z',
      status: 'active',
      progressPercentage: 25,
      location: 'Test Location',
      beneficiariesCount: 500,
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-01T00:00:00.000Z',
      createdBy: 'test@example.com',
    ),
    const ProjectModel(
      id: '2',
      projectCode: 'HLT-002',
      title: 'Test Project 2',
      description: 'Test Description 2',
      recipientId: 'REC-002',
      sector: 'health',
      estimatedBudget: 200000.0,
      actualExpenditure: 50000.0,
      startDate: '2024-02-01T00:00:00.000Z',
      endDate: '2024-11-30T23:59:59.000Z',
      status: 'active',
      progressPercentage: 30,
      location: 'Test Location 2',
      beneficiariesCount: 1000,
      createdAt: '2024-02-01T00:00:00.000Z',
      updatedAt: '2024-02-01T00:00:00.000Z',
      createdBy: 'test2@example.com',
    ),
  ];

  group('getProjects', () {
    test('should return list of projects when call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProjects();

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, List<Project>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (projects) {
          expect(projects.length, equals(2));
          expect(projects[0].id, equals('1'));
          expect(projects[0].title, equals('Test Project 1'));
          expect(projects[1].id, equals('2'));
          expect(projects[1].title, equals('Test Project 2'));
        },
      );
    });

    test('should return filtered projects when recipientId filter is applied', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProjects(recipientId: 'REC-001');

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, List<Project>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (projects) {
          expect(projects.length, equals(1));
          expect(projects[0].recipientId, equals('REC-001'));
        },
      );
    });

    test('should return filtered projects when status filter is applied', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProjects(status: ProjectStatus.active);

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, List<Project>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (projects) {
          expect(projects.length, equals(2));
          expect(projects.every((p) => p.status == ProjectStatus.active), isTrue);
        },
      );
    });

    test('should return filtered projects when sector filter is applied', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProjects(sector: ProjectSector.education);

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, List<Project>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (projects) {
          expect(projects.length, equals(1));
          expect(projects[0].sector, equals(ProjectSector.education));
        },
      );
    });

    test('should return paginated projects when page and limit are provided', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProjects(page: 0, limit: 1);

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, List<Project>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (projects) {
          expect(projects.length, equals(1));
          expect(projects[0].id, equals('1'));
        },
      );
    });

    test('should return ServerFailure when call to remote data source throws exception', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenThrow(Exception('Network error'));

      // act
      final result = await repository.getProjects();

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Left<Failure, List<Project>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Failed to fetch projects'));
        },
        (projects) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getProject', () {
    test('should return project when call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProject('1');

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, Project>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (project) {
          expect(project.id, equals('1'));
          expect(project.title, equals('Test Project 1'));
        },
      );
    });

    test('should return ServerFailure when project is not found', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProject('999');

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Left<Failure, Project>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals('Project not found'));
        },
        (project) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getProjectsByRecipient', () {
    test('should return projects filtered by recipient', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProjectsByRecipient('REC-001');

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, List<Project>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (projects) {
          expect(projects.length, equals(1));
          expect(projects[0].recipientId, equals('REC-001'));
        },
      );
    });
  });

  group('getProjectsBySector', () {
    test('should return projects filtered by sector', () async {
      // arrange
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => tProjectModels);

      // act
      final result = await repository.getProjectsBySector(ProjectSector.health);

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, List<Project>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (projects) {
          expect(projects.length, equals(1));
          expect(projects[0].sector, equals(ProjectSector.health));
        },
      );
    });
  });

  group('getOverdueProjects', () {
    test('should return overdue projects', () async {
      // arrange
      final overdueProjectModel = ProjectModel(
        id: '3',
        projectCode: 'OLD-003',
        title: 'Overdue Project',
        description: 'This project is overdue',
        recipientId: 'REC-003',
        sector: 'infrastructure',
        estimatedBudget: 50000.0,
        actualExpenditure: 25000.0,
        startDate: '2023-01-01T00:00:00.000Z',
        endDate: '2023-12-31T23:59:59.000Z', // Past date
        status: 'active', // Not completed but past end date
        progressPercentage: 50,
        location: 'Test Location 3',
        beneficiariesCount: 200,
        createdAt: '2023-01-01T00:00:00.000Z',
        updatedAt: '2023-01-01T00:00:00.000Z',
        createdBy: 'test3@example.com',
      );
      
      when(mockRemoteDataSource.getAllProjects())
          .thenAnswer((_) async => [...tProjectModels, overdueProjectModel]);

      // act
      final result = await repository.getOverdueProjects();

      // assert
      verify(mockRemoteDataSource.getAllProjects());
      expect(result, isA<Right<Failure, List<Project>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (projects) {
          expect(projects.length, equals(1));
          expect(projects[0].id, equals('3'));
          expect(projects[0].isOverdue, isTrue);
        },
      );
    });
  });
}