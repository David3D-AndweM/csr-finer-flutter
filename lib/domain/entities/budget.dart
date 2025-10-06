import 'package:equatable/equatable.dart';
import 'project.dart';

enum BudgetStatus {
  draft,
  pendingApproval,
  approved,
  active,
  closed,
}

class Budget extends Equatable {
  final String id;
  final int financialYear;
  final double totalBudget;
  final double allocatedAmount;
  final double spentAmount;
  final BudgetStatus status;
  final DateTime? approvedDate;
  final String? approvedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final List<BudgetAllocation> allocations;

  const Budget({
    required this.id,
    required this.financialYear,
    required this.totalBudget,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.status,
    this.approvedDate,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.allocations,
  });

  double get remainingAmount => totalBudget - spentAmount;
  
  double get unallocatedAmount => totalBudget - allocatedAmount;
  
  double get utilizationPercentage {
    if (totalBudget == 0) return 0;
    return (spentAmount / totalBudget) * 100;
  }
  
  double get allocationPercentage {
    if (totalBudget == 0) return 0;
    return (allocatedAmount / totalBudget) * 100;
  }
  
  bool get isApproved => status == BudgetStatus.approved || status == BudgetStatus.active;
  
  bool get isActive => status == BudgetStatus.active;
  
  bool get isOverAllocated => allocatedAmount > totalBudget;
  
  bool get isOverSpent => spentAmount > totalBudget;
  
  String get statusDisplayName {
    switch (status) {
      case BudgetStatus.draft:
        return 'Draft';
      case BudgetStatus.pendingApproval:
        return 'Pending Approval';
      case BudgetStatus.approved:
        return 'Approved';
      case BudgetStatus.active:
        return 'Active';
      case BudgetStatus.closed:
        return 'Closed';
    }
  }

  Budget copyWith({
    String? id,
    int? financialYear,
    double? totalBudget,
    double? allocatedAmount,
    double? spentAmount,
    BudgetStatus? status,
    DateTime? approvedDate,
    String? approvedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    List<BudgetAllocation>? allocations,
  }) {
    return Budget(
      id: id ?? this.id,
      financialYear: financialYear ?? this.financialYear,
      totalBudget: totalBudget ?? this.totalBudget,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      status: status ?? this.status,
      approvedDate: approvedDate ?? this.approvedDate,
      approvedBy: approvedBy ?? this.approvedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      allocations: allocations ?? this.allocations,
    );
  }

  @override
  List<Object?> get props => [
        id,
        financialYear,
        totalBudget,
        allocatedAmount,
        spentAmount,
        status,
        approvedDate,
        approvedBy,
        createdAt,
        updatedAt,
        createdBy,
        allocations,
      ];
}

class BudgetAllocation extends Equatable {
  final String id;
  final String budgetId;
  final ProjectSector sector;
  final double allocatedAmount;
  final double spentAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetAllocation({
    required this.id,
    required this.budgetId,
    required this.sector,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingAmount => allocatedAmount - spentAmount;
  
  double get utilizationPercentage {
    if (allocatedAmount == 0) return 0;
    return (spentAmount / allocatedAmount) * 100;
  }
  
  bool get isOverSpent => spentAmount > allocatedAmount;
  
  String get sectorDisplayName {
    switch (sector) {
      case ProjectSector.education:
        return 'Education';
      case ProjectSector.health:
        return 'Health';
      case ProjectSector.infrastructure:
        return 'Infrastructure';
      case ProjectSector.agriculture:
        return 'Agriculture';
      case ProjectSector.environment:
        return 'Environment';
      case ProjectSector.technology:
        return 'Technology';
      case ProjectSector.communityDevelopment:
        return 'Community Development';
      case ProjectSector.other:
        return 'Other';
    }
  }

  BudgetAllocation copyWith({
    String? id,
    String? budgetId,
    ProjectSector? sector,
    double? allocatedAmount,
    double? spentAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetAllocation(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      sector: sector ?? this.sector,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        budgetId,
        sector,
        allocatedAmount,
        spentAmount,
        createdAt,
        updatedAt,
      ];
}
