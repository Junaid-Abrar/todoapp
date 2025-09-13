import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todoapp/service/auth_service.dart';
import 'package:todoapp/theme/app_theme.dart';
import 'package:todoapp/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final AuthClass _authClass = AuthClass();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isEditing = false;
  bool _isLoading = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadUserData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _displayNameController.text = _currentUser!.displayName ?? '';
      _emailController.text = _currentUser!.email ?? '';
    }
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
               
              const Spacer(),
              
              if (!_isEditing)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: AppConstants.iconMedium,
                  ),
                ).animate(controller: _animationController)
                 .fadeIn(delay: const Duration(milliseconds: 200))
                 .slideX(begin: 0.3),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacing16),
          
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: _currentUser?.photoURL != null
                ? ClipOval(
                    child: Image.network(
                      _currentUser!.photoURL!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: AppConstants.iconExtraLarge,
                          color: Colors.white,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: AppConstants.iconExtraLarge,
                    color: Colors.white,
                  ),
          ).animate(controller: _animationController)
           .scale(delay: const Duration(milliseconds: 200)),
           
          const SizedBox(height: AppConstants.spacing16),
          
          Text(
            _currentUser?.displayName?.isNotEmpty == true 
                ? _currentUser!.displayName!
                : 'User Profile',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 300))
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
              'Profile Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ).animate(controller: _animationController)
             .fadeIn(delay: const Duration(milliseconds: 400))
             .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing24),
            
            _buildTextField(
              controller: _displayNameController,
              label: 'Display Name',
              icon: Icons.person_outline,
              enabled: _isEditing,
            ).animate(controller: _animationController)
             .fadeIn(delay: const Duration(milliseconds: 500))
             .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing20),
            
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              enabled: false, // Email cannot be changed
            ).animate(controller: _animationController)
             .fadeIn(delay: const Duration(milliseconds: 600))
             .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing24),
            
            _buildAccountInfo(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 700))
                .slideY(begin: 0.2),
            
            const SizedBox(height: AppConstants.spacing32),
            
            if (_isEditing) _buildActionButtons(theme)
                .animate(controller: _animationController)
                .fadeIn(delay: const Duration(milliseconds: 800))
                .slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: enabled 
            ? Theme.of(context).colorScheme.surface 
            : Theme.of(context).colorScheme.surface.withOpacity(0.5),
      ),
      validator: (value) {
        if (label == 'Display Name' && (value == null || value.trim().isEmpty)) {
          return 'Display name cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildAccountInfo(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacing12),
            _buildInfoRow('User ID', _currentUser?.uid ?? 'N/A', theme),
            _buildInfoRow('Email Verified', 
                _currentUser?.emailVerified == true ? 'Yes' : 'No', theme),
            _buildInfoRow('Account Created', 
                _formatDate(_currentUser?.metadata.creationTime), theme),
            _buildInfoRow('Last Sign In', 
                _formatDate(_currentUser?.metadata.lastSignInTime), theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () {
              setState(() {
                _isEditing = false;
                _loadUserData(); // Reset to original values
              });
            },
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: AppConstants.spacing16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      await _currentUser?.updateDisplayName(_displayNameController.text.trim());
      await _currentUser?.reload();
      
      setState(() {
        _currentUser = FirebaseAuth.instance.currentUser;
        _isEditing = false;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}