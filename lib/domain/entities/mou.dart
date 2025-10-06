import 'package:equatable/equatable.dart';

enum MouStatus {
  draft,
  pendingApproval,
  active,
  completed,
  terminated,
  expired,
}

class Mou extends Equatable {
  final String id;
  final String mouNumber;
  final String title;
  final String description;
  final String recipientId;
  final String? organizationId;
  final double totalAmount;
  final double disbursedAmount;
  final DateTime startDate;
  final DateTime endDate;
  final MouStatus status;
  final DateTime? signedDate;
  final String? documentUrl;
  final String? termsConditions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? updatedBy;

  const Mou({
    required this.id,
    required this.mouNumber,
    required this.title,
    required this.description,
    required this.recipientId,
    this.organizationId,
    required this.totalAmount,
    required this.disbursedAmount,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.signedDate,
    this.documentUrl,
    this.termsConditions,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
  });

  double get remainingAmount => totalAmount - disbursedAmount;
  
  bool get isActive => status == MouStatus.active;
  
  bool get isCompleted => status == MouStatus.completed;
  
  bool get isExpired => DateTime.now().isAfter(endDate) && !isCompleted;
  
  bool get isSigned => signedDate != null;
  
  double get disbursementPercentage {
    if (totalAmount == 0) return 0;
    return (disbursedAmount / totalAmount) * 100;
  }
  
  Duration get duration => endDate.difference(startDate);
  
  Duration get remainingDuration {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return Duration.zero;
    return endDate.difference(now);
  }
  
  String get statusDisplayName {
    switch (status) {
      case MouStatus.draft:
        return 'Draft';
      case MouStatus.pendingApproval:
        return 'Pending Approval';
      case MouStatus.active:
        return 'Active';
      case MouStatus.completed:
        return 'Completed';
      case MouStatus.terminated:
        return 'Terminated';
      case MouStatus.expired:
        return 'Expired';
    }
  }

  Mou copyWith({
    String? id,
    String? mouNumber,
    String? title,
    String? description,
    String? recipientId,
    String? organizationId,
    double? totalAmount,
    double? disbursedAmount,
    DateTime? startDate,
    DateTime? endDate,
    MouStatus? status,
    DateTime? signedDate,
    String? documentUrl,
    String? termsConditions,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return Mou(
      id: id ?? this.id,
      mouNumber: mouNumber ?? this.mouNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      recipientId: recipientId ?? this.recipientId,
      organizationId: organizationId ?? this.organizationId,
      totalAmount: totalAmount ?? this.totalAmount,
      disbursedAmount: disbursedAmount ?? this.disbursedAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      signedDate: signedDate ?? this.signedDate,
      documentUrl: documentUrl ?? this.documentUrl,
      termsConditions: termsConditions ?? this.termsConditions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        mouNumber,
        title,
        description,
        recipientId,
        organizationId,
        totalAmount,
        disbursedAmount,
        startDate,
        endDate,
        status,
        signedDate,
        documentUrl,
        termsConditions,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy,
      ];
}
