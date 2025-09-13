import 'package:cloud_firestore/cloud_firestore.dart';

enum TodoPriority { low, medium, high }
enum TodoStatus { pending, completed }

class TodoModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final TodoPriority priority;
  final TodoStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String userId;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    required this.userId,
  });

  // Convert TodoModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'userId': userId,
    };
  }

  // Create TodoModel from Firestore document
  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return TodoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Personal',
      priority: _stringToPriority(data['priority'] ?? 'medium'),
      status: _stringToStatus(data['status'] ?? 'pending'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      userId: data['userId'] ?? '',
    );
  }

  // Create TodoModel from Map
  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    return TodoModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Personal',
      priority: _stringToPriority(map['priority'] ?? 'medium'),
      status: _stringToStatus(map['status'] ?? 'pending'),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (map['dueDate'] as Timestamp?)?.toDate(),
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
      userId: map['userId'] ?? '',
    );
  }

  // Helper method to convert string to TodoPriority
  static TodoPriority _stringToPriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return TodoPriority.high;
      case 'low':
        return TodoPriority.low;
      default:
        return TodoPriority.medium;
    }
  }

  // Helper method to convert string to TodoStatus
  static TodoStatus _stringToStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return TodoStatus.completed;
      default:
        return TodoStatus.pending;
    }
  }

  // Create a copy of the todo with updated fields
  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    TodoPriority? priority,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    String? userId,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      userId: userId ?? this.userId,
    );
  }

  bool get isCompleted => status == TodoStatus.completed;
  bool get isPending => status == TodoStatus.pending;
  bool get isOverdue => dueDate != null && 
      dueDate!.isBefore(DateTime.now()) && 
      status == TodoStatus.pending;

  String get priorityText {
    switch (priority) {
      case TodoPriority.high:
        return 'High';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.low:
        return 'Low';
    }
  }

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, category: $category, priority: $priority, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is TodoModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.priority == priority &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.dueDate == dueDate &&
        other.completedAt == completedAt &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        priority.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        dueDate.hashCode ^
        completedAt.hashCode ^
        userId.hashCode;
  }
}