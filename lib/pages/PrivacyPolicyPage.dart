import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todoapp/utils/constants.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> with TickerProviderStateMixin {
  late AnimationController _animationController;

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
            Icons.privacy_tip_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.9),
          ).animate(controller: _animationController)
           .scale(delay: const Duration(milliseconds: 200)),
           
          const SizedBox(height: AppConstants.spacing16),
          
          Text(
            'Privacy Policy',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 300))
           .slideY(begin: 0.3),
           
          const SizedBox(height: AppConstants.spacing8),
          
          Text(
            'How we protect your data',
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
          _buildSection(
            title: 'Information We Collect',
            content: '''We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support. This may include:

• Email address and account credentials
• Profile information (name, profile picture)
• Todo items and task data
• Usage analytics and app performance data''',
            icon: Icons.info_outline,
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 500))
           .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing24),
          
          _buildSection(
            title: 'How We Use Your Information',
            content: '''We use the information we collect to:

• Provide, maintain, and improve our services
• Process transactions and manage your account
• Send you technical notices and support messages
• Respond to your comments and questions
• Analyze usage patterns to enhance user experience''',
            icon: Icons.settings_applications,
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 600))
           .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing24),
          
          _buildSection(
            title: 'Data Security',
            content: '''We take data security seriously and implement appropriate measures to protect your information:

• All data is encrypted in transit and at rest
• We use Firebase's secure infrastructure
• Regular security audits and updates
• Access controls and authentication mechanisms
• Automatic logout for inactive sessions''',
            icon: Icons.security,
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 700))
           .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing24),
          
          _buildSection(
            title: 'Your Rights',
            content: '''You have the right to:

• Access, update, or delete your personal information
• Export your data in a portable format
• Opt out of certain communications
• Request account deletion
• Contact us with privacy concerns''',
            icon: Icons.gavel,
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 800))
           .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing24),
          
          _buildSection(
            title: 'Third-Party Services',
            content: '''Our app uses the following third-party services:

• Firebase (Google) - for authentication and data storage
• Google Sign-In - for authentication services
• Analytics services - for app improvement

These services have their own privacy policies and data handling practices.''',
            icon: Icons.link,
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 900))
           .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing24),
          
          _buildSection(
            title: 'Contact Us',
            content: '''If you have any questions about this Privacy Policy or our data practices, please contact us:

• Email: support@todoapp.com
• Through the app's feedback feature
• Via the settings page in the app

We will respond to your inquiry within 48 hours.''',
            icon: Icons.contact_support,
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 1000))
           .slideY(begin: 0.2),
          
          const SizedBox(height: AppConstants.spacing32),
          
          Center(
            child: Text(
              'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ).animate(controller: _animationController)
           .fadeIn(delay: const Duration(milliseconds: 1100))
           .slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: AppConstants.iconMedium,
                ),
                const SizedBox(width: AppConstants.spacing12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacing16),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}