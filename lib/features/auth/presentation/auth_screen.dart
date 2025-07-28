import 'package:flutter/material.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/logger.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = FirebaseService.getCurrentUser();
    if (user != null) {
      AppLogger.info('User already authenticated: ${user.email}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masses Social')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rss_feed, size: 80, color: Colors.blue),
            SizedBox(height: 24),
            Text(
              'Masses Social',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your decentralized social media aggregator',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Text(
              'Phase 1: Foundation Architecture\nImplemented Successfully! 🎉',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
import '../../../app/app_theme.dart';  // ← New import

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = FirebaseService.getCurrentUser();
    if (user != null) {
      AppLogger.info('User already authenticated: ${user.email}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masses Social'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rss_feed, size: 80, color: AppTheme.primaryColor),
            const SizedBox(height: 24),
            Text(
              'Masses Social',
              style: AppTheme.headlineStyle,
            ),
            const SizedBox(height: 8),
            Text(
              'Your decentralized social media aggregator',
              style: AppTheme.captionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.successColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.successColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phase 1: Foundation Architecture',
                    style: AppTheme.titleStyle.copyWith(
                      color: AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Implemented Successfully! 🎉',
                    style: AppTheme.bodyStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}