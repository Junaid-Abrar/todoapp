import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/pages/ChangePasswordPage.dart';
import 'package:todoapp/pages/FeedbackPage.dart';
import 'package:todoapp/pages/PrivacyPolicyPage.dart';
import 'package:todoapp/pages/ProfilePage.dart';
import 'package:todoapp/providers/theme_provider.dart';
import 'package:todoapp/service/auth_service.dart';
import 'package:todoapp/theme/app_theme.dart';
import 'package:todoapp/utils/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final AuthClass _authClass = AuthClass();
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

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
              _buildHeader(theme, currentUser),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: AppConstants.spacing20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppConstants.borderRadius24),
                    ),
                  ),
                  child: _buildContent(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, User? currentUser) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      child: Column(
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
            ],
          ),
          
          const SizedBox(height: AppConstants.spacing16),
          
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.person,
              size: AppConstants.iconExtraLarge,
              color: Colors.white,
            ),
          ).animate(controller: _animationController)
           .scale(delay: const Duration(milliseconds: 200)),
           
          const SizedBox(height: AppConstants.spacing16),
          
          Text(
            currentUser?.email ?? 'User',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 300))
           .slideY(begin: 0.3),
           
          const SizedBox(height: AppConstants.spacing4),
          
          Text(
            'Manage your account and preferences',
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

  Widget _buildContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Appearance', Icons.palette, theme)
              .animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 500))
              .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing16),
          
          _buildThemeCard(theme)
              .animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 600))
              .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing32),
          
          _buildSectionTitle('Preferences', Icons.tune, theme)
              .animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 700))
              .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing16),
          
          _buildPreferencesCard(theme)
              .animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 800))
              .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing32),
          
          _buildSectionTitle('Account', Icons.account_circle, theme)
              .animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 900))
              .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing16),
          
          _buildAccountCard(theme)
              .animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 1000))
              .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing32),
          
          _buildSectionTitle('About', Icons.info, theme)
              .animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 1100))
              .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing16),
          
          _buildAboutCard(theme)
              .animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 1200))
              .slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: AppConstants.iconMedium,
        ),
        const SizedBox(width: AppConstants.spacing8),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
      ),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return SwitchListTile(
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
            activeColor: theme.colorScheme.primary,
            title: Text(
              'Dark Mode',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              themeProvider.isDarkMode 
                  ? 'Switch to light theme'
                  : 'Switch to dark theme',
              style: theme.textTheme.bodySmall,
            ),
            secondary: Icon(
              themeProvider.isDarkMode 
                  ? Icons.dark_mode 
                  : Icons.light_mode,
              color: theme.colorScheme.primary,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreferencesCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
      ),
      child: Column(
        children: [
          SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: theme.colorScheme.primary,
            title: Text(
              'Notifications',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              _notificationsEnabled 
                  ? 'Receive task reminders'
                  : 'No notifications',
              style: theme.textTheme.bodySmall,
            ),
            secondary: Icon(
              Icons.notifications,
              color: theme.colorScheme.primary,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.language,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Language',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              'English (US)',
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Implement language selection
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.person,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Profile',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              'Edit your profile information',
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.lock,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Change Password',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              'Update your password',
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: AppTheme.errorColor,
            ),
            title: Text(
              'Logout',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
            subtitle: Text(
              'Sign out of your account',
              style: theme.textTheme.bodySmall,
            ),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.info,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'About',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              'App information and credits',
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Professional Todo App",
                applicationVersion: "2.0.0",
                applicationLegalese: "© 2025 Junaid Ahmed\nBuilt with Flutter",
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'A professional todo application with modern design and powerful features.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.privacy_tip,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Privacy Policy',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              'How we protect your data',
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.feedback,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Send Feedback',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              'Help us improve the app',
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _authClass.logout();
                // Navigate to login and clear all routes
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', 
                    (Route<dynamic> route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}