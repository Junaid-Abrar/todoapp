import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/theme/app_theme.dart';
import 'package:todoapp/utils/constants.dart';
import 'package:todoapp/utils/date_utils.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleComplete;
  final VoidCallback? onDelete;
  final bool isSelected;

  const TodoCard({
    Key? key,
    required this.todo,
    this.onTap,
    this.onToggleComplete,
    this.onDelete,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing8,
      ),
      child: Material(
        elevation: isSelected ? 4 : 2,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
        color: isSelected 
            ? colorScheme.primary.withOpacity(0.1)
            : colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
              border: isSelected 
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                // Checkbox
                _buildCheckbox(theme),
                
                const SizedBox(width: AppConstants.spacing12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleRow(theme),
                      const SizedBox(height: AppConstants.spacing4),
                      if (todo.description.isNotEmpty) ...[
                        _buildDescription(theme),
                        const SizedBox(height: AppConstants.spacing8),
                      ],
                      _buildMetadataRow(theme),
                    ],
                  ),
                ),
                
                // Priority indicator
                _buildPriorityIndicator(theme),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: AppConstants.mediumAnimation)
     .slideX(begin: 0.3, duration: AppConstants.mediumAnimation);
  }

  Widget _buildCheckbox(ThemeData theme) {
    return GestureDetector(
      onTap: () => onToggleComplete?.call(!todo.isCompleted),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: todo.isCompleted 
                ? AppTheme.categoryColors[todo.category] ?? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 2,
          ),
          color: todo.isCompleted 
              ? AppTheme.categoryColors[todo.category] ?? theme.colorScheme.primary
              : Colors.transparent,
        ),
        child: todo.isCompleted
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  Widget _buildTitleRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            todo.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: todo.isCompleted 
                  ? TextDecoration.lineThrough 
                  : null,
              color: todo.isCompleted 
                  ? theme.colorScheme.onSurface.withOpacity(0.6)
                  : theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (todo.isOverdue) ...[
          const SizedBox(width: AppConstants.spacing8),
          Icon(
            Icons.schedule,
            size: AppConstants.iconSmall,
            color: AppTheme.errorColor,
          ),
        ],
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      todo.description,
      style: theme.textTheme.bodySmall?.copyWith(
        color: todo.isCompleted 
            ? theme.colorScheme.onSurface.withOpacity(0.4)
            : theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadataRow(ThemeData theme) {
    return Row(
      children: [
        // Category chip
        _buildCategoryChip(theme),
        
        const SizedBox(width: AppConstants.spacing8),
        
        // Due date
        if (todo.dueDate != null) ...[
          Icon(
            Icons.access_time,
            size: AppConstants.iconSmall,
            color: todo.isOverdue 
                ? AppTheme.errorColor 
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: AppConstants.spacing4),
          Text(
            AppDateUtils.formatDate(todo.dueDate!),
            style: theme.textTheme.bodySmall?.copyWith(
              color: todo.isOverdue 
                  ? AppTheme.errorColor 
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        
        const Spacer(),
        
        // Created date
        Text(
          AppDateUtils.formatDate(todo.createdAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(ThemeData theme) {
    final categoryColor = AppTheme.categoryColors[todo.category] ?? 
                         theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing8,
        vertical: AppConstants.spacing4,
      ),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius8),
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CategoryIcons.getIcon(todo.category),
            size: 12,
            color: categoryColor,
          ),
          const SizedBox(width: AppConstants.spacing4),
          Text(
            todo.category,
            style: theme.textTheme.labelSmall?.copyWith(
              color: categoryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator(ThemeData theme) {
    final priorityColor = AppTheme.priorityColors[todo.priorityText] ?? 
                         theme.colorScheme.secondary;
    
    return Container(
      width: 4,
      height: 40,
      decoration: BoxDecoration(
        color: priorityColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}