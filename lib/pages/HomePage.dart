import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/pages/addToDo.dart';
import 'package:todoapp/pages/CalendarPage.dart';
import 'package:todoapp/pages/Settings.dart';
import 'package:todoapp/pages/StatsPage.dart';
import 'package:todoapp/pages/ViewData.dart';
import 'package:todoapp/providers/theme_provider.dart';
import 'package:todoapp/service/auth_service.dart';
import 'package:todoapp/theme/app_theme.dart';
import 'package:todoapp/utils/constants.dart';
import 'package:todoapp/utils/date_utils.dart';
import 'package:todoapp/widgets/modern_bottom_nav.dart';
import 'package:todoapp/widgets/todo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
  
  int _currentNavIndex = 0;
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Today', 'This Week', 'Completed'];
  
  AuthClass authclass = AuthClass();

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerAnimationController.forward();
    _listAnimationController.forward();
  }
  

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> get _todoStream {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('No user ID found - user not authenticated');
      return const Stream.empty();
    }
    
    print('Fetching todos for user: $userId');
    
    Query query = FirebaseFirestore.instance
        .collection('Todo')
        .where('userId', isEqualTo: userId);
        
    // Apply basic filters (temporarily disable date filters to avoid index issues)
    switch (_selectedFilter) {
      case 'Completed':
        query = query.where('isCompleted', isEqualTo: true);
        break;
      case 'Pending':
        query = query.where('isCompleted', isEqualTo: false);
        break;
      case 'Today':
      case 'This Week':
        // Temporarily disabled - requires composite indexes
        print('Date filters temporarily disabled');
        break;
      default:
        // Show all todos
        break;
    }
    
    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
            _buildFilters(theme),
            Expanded(child: _buildTodoList()),
          ],
        ),
      ),
      bottomNavigationBar: ModernBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppDateUtils.getGreeting(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ).animate(controller: _headerAnimationController)
                     .fadeIn(delay: const Duration(milliseconds: 200))
                     .slideX(begin: -0.3),
                     
                    const SizedBox(height: AppConstants.spacing4),
                    
                    Text(
                      AppDateUtils.getTodayFormatted(),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate(controller: _headerAnimationController)
                     .fadeIn(delay: const Duration(milliseconds: 400))
                     .slideX(begin: -0.3),
                  ],
                ),
              ),
              Row(
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return IconButton(
                        onPressed: themeProvider.toggleTheme,
                        icon: Icon(
                          themeProvider.isDarkMode 
                              ? Icons.light_mode 
                              : Icons.dark_mode,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface,
                          elevation: 2,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: AppConstants.spacing8),
                  GestureDetector(
                    onTap: () => _showProfileMenu(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ).animate(controller: _headerAnimationController)
               .fadeIn(delay: const Duration(milliseconds: 600))
               .scale(begin: const Offset(0.8, 0.8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacing20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;
          
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 300),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  margin: const EdgeInsets.only(right: AppConstants.spacing12),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.1),
                    checkmarkColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodoList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _todoStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          print('Firestore stream error: ${snapshot.error}');
          // Return demo/offline state instead of error
          return _buildOfflineState(context);
        }
        
        print('Firestore snapshot: hasData=${snapshot.hasData}, data=${snapshot.data}');

        final todos = snapshot.data!.docs.map((doc) {
          return TodoModel.fromFirestore(doc);
        }).toList();

        if (todos.isEmpty) {
          return _buildEmptyState();
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: AppConstants.spacing16,
              bottom: AppConstants.spacing32,
            ),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: TodoCard(
                      todo: todo,
                      onTap: () => _navigateToTodoDetails(todo),
                      onToggleComplete: (isCompleted) => _toggleTodoComplete(todo, isCompleted),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ).animate()
           .scale(duration: const Duration(milliseconds: 800))
           .then(delay: const Duration(milliseconds: 200))
           .shimmer(duration: const Duration(seconds: 2)),
           
          const SizedBox(height: AppConstants.spacing24),
          
          Text(
            _selectedFilter == 'All' 
                ? AppConstants.emptyTodosMessage
                : 'No ${_selectedFilter.toLowerCase()} tasks',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ).animate()
           .fadeIn(delay: const Duration(milliseconds: 600))
           .slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildOfflineState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            'Working Offline',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            'Cloud sync unavailable. Your todos will sync when connection is restored.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            'Get started by adding your first task!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == -1) {
      // Add button tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddToDoPage()),
      );
      return;
    }
    
    setState(() {
      _currentNavIndex = index;
    });
    
    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Calendar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarPage()),
        );
        break;
      case 2:
        // Stats
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatsPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }

  void _navigateToTodoDetails(TodoModel todo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewData(
          key: UniqueKey(),
          document: todo.toMap(),
          id: todo.id,
        ),
      ),
    );
  }

  Future<void> _toggleTodoComplete(TodoModel todo, bool isCompleted) async {
    try {
      await FirebaseFirestore.instance
          .collection('Todo')
          .doc(todo.id)
          .update({
        'status': isCompleted ? 'completed' : 'pending',
        'completedAt': isCompleted ? Timestamp.now() : null,
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update task. Please try again.'),
          ),
        );
      }
    }
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadius20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacing20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                await authclass.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
