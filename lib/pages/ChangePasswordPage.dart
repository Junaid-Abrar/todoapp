import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todoapp/theme/app_theme.dart';
import 'package:todoapp/utils/constants.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

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
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
              _buildHeader(theme),
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

  Widget _buildHeader(ThemeData theme) {
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
          
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Colors.white.withOpacity(0.9),
          ).animate(controller: _animationController)
           .scale(delay: const Duration(milliseconds: 200)),
           
          const SizedBox(height: AppConstants.spacing16),
          
          Text(
            'Change Password',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 300))
           .slideY(begin: 0.3),
           
          const SizedBox(height: AppConstants.spacing8),
          
          Text(
            'Update your account password',
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security Requirements',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ).animate(controller: _animationController)
             .fadeIn(delay: const Duration(milliseconds: 500))
             .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing8),
            
            _buildRequirementsList(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 600))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing32),
            
            _buildPasswordField(
              controller: _currentPasswordController,
              label: 'Current Password',
              isVisible: _showCurrentPassword,
              onToggleVisibility: () => setState(() => _showCurrentPassword = !_showCurrentPassword),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password';
                }
                return null;
              },
            ).animate(controller: _animationController)
             .fadeIn(delay: const Duration(milliseconds: 700))
             .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing20),
            
            _buildPasswordField(
              controller: _newPasswordController,
              label: 'New Password',
              isVisible: _showNewPassword,
              onToggleVisibility: () => setState(() => _showNewPassword = !_showNewPassword),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                if (value == _currentPasswordController.text) {
                  return 'New password must be different from current password';
                }
                return null;
              },
            ).animate(controller: _animationController)
             .fadeIn(delay: const Duration(milliseconds: 800))
             .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing20),
            
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm New Password',
              isVisible: _showConfirmPassword,
              onToggleVisibility: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ).animate(controller: _animationController)
             .fadeIn(delay: const Duration(milliseconds: 900))
             .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing32),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
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
                          const Icon(Icons.security),
                          const SizedBox(width: AppConstants.spacing8),
                          Text(
                            'Update Password',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ).animate(controller: _animationController)
             .fadeIn(delay: const Duration(milliseconds: 1000))
             .slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsList(ThemeData theme) {
    final requirements = [
      'Password must be at least 6 characters long',
      'Use a combination of letters, numbers, and symbols',
      'New password must be different from current password',
    ];

    return Card(
      color: theme.colorScheme.surface.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          children: requirements.map((req) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppConstants.spacing8),
                Expanded(
                  child: Text(
                    req,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(_newPasswordController.text);
      
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      String errorMessage = 'Failed to update password';
      if (e.toString().contains('wrong-password')) {
        errorMessage = 'Current password is incorrect';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'New password is too weak';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}