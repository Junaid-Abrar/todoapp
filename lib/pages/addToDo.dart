import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/pages/HomePage.dart';
import 'package:todoapp/theme/app_theme.dart';
import 'package:todoapp/utils/constants.dart';
import 'package:uuid/uuid.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _selectedPriority = AppConstants.defaultPriority;
  String _selectedCategory = AppConstants.defaultCategory;
  DateTime? _selectedDueDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(theme),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: AppConstants.spacing20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppConstants.borderRadius24),
                    ),
                  ),
                  child: _buildForm(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: AppConstants.iconMedium,
                ),
              ).animate(controller: _animationController)
               .fadeIn(delay: const Duration(milliseconds: 100))
               .slideX(begin: -0.3),
               
              const Spacer(),
              
              IconButton(
                onPressed: _saveTodo,
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: AppConstants.iconMedium,
                ),
              ).animate(controller: _animationController)
               .fadeIn(delay: const Duration(milliseconds: 200))
               .slideX(begin: 0.3),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacing16),
          
          Text(
            'Create New Task',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 300))
           .slideY(begin: 0.3),
           
          const SizedBox(height: AppConstants.spacing8),
          
          Text(
            'Add a new task to your todo list',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 400))
           .slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Task Details', theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 500))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing16),
            
            _buildTitleField(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 600))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing20),
            
            _buildDescriptionField(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 700))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing32),
            
            _buildSectionTitle('Priority', theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 800))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing16),
            
            _buildPrioritySelector(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 900))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing32),
            
            _buildSectionTitle('Category', theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 1000))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing16),
            
            _buildCategorySelector(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 1100))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing32),
            
            _buildDueDateSelector(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 1200))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing32),
            
            _buildSaveButton(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 1300))
                .slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Task Title',
        hintText: 'Enter task title...',
        prefixIcon: const Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a task title';
        }
        if (value.trim().length < AppConstants.minTitleLength) {
          return 'Title must be at least ${AppConstants.minTitleLength} character';
        }
        if (value.length > AppConstants.maxTitleLength) {
          return 'Title must be less than ${AppConstants.maxTitleLength} characters';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Description (Optional)',
        hintText: 'Enter task description...',
        prefixIcon: const Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value != null && value.length > AppConstants.maxDescriptionLength) {
          return 'Description must be less than ${AppConstants.maxDescriptionLength} characters';
        }
        return null;
      },
    );
  }

  Widget _buildPrioritySelector(ThemeData theme) {
    return Wrap(
      spacing: AppConstants.spacing12,
      children: AppConstants.priorityLevels.map((priority) {
        final isSelected = _selectedPriority == priority;
        final color = AppTheme.priorityColors[priority] ?? theme.colorScheme.primary;
        
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PriorityIcons.getIcon(priority),
                size: AppConstants.iconSmall,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: AppConstants.spacing4),
              Text(priority),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedPriority = priority;
            });
          },
          backgroundColor: theme.colorScheme.surface,
          selectedColor: color,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Wrap(
      spacing: AppConstants.spacing12,
      runSpacing: AppConstants.spacing8,
      children: AppConstants.todoCategories.map((category) {
        final isSelected = _selectedCategory == category;
        final color = AppTheme.categoryColors[category] ?? theme.colorScheme.primary;
        
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CategoryIcons.getIcon(category),
                size: AppConstants.iconSmall,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: AppConstants.spacing4),
              Text(category),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedCategory = category;
            });
          },
          backgroundColor: theme.colorScheme.surface,
          selectedColor: color,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDueDateSelector(ThemeData theme) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: const Text('Due Date'),
        subtitle: Text(
          _selectedDueDate != null 
              ? '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
              : 'No due date set',
        ),
        trailing: _selectedDueDate != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDueDate = null;
                  });
                },
                icon: const Icon(Icons.clear),
              )
            : null,
        onTap: _showDatePicker,
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveTodo,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_task),
                  const SizedBox(width: AppConstants.spacing8),
                  Text(
                    'Create Task',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (selectedDate != null) {
      setState(() {
        _selectedDueDate = selectedDate;
      });
    }
  }

  Future<void> _saveTodo() async {
    if (!_formKey.currentState!.validate()) return;
    
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to create tasks')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final todo = TodoModel(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        priority: TodoPriority.values.firstWhere(
          (p) => p.toString().split('.').last.toLowerCase() == 
                 _selectedPriority.toLowerCase(),
        ),
        status: TodoStatus.pending,
        createdAt: DateTime.now(),
        dueDate: _selectedDueDate,
        userId: currentUser.uid,
      );

      await FirebaseFirestore.instance
          .collection('Todo')
          .doc(todo.id)
          .set(todo.toMap());

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create task. Please try again.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
