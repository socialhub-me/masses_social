import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/firebase_service.dart';
import 'core/di/injection_container.dart';
import 'core/utils/logger.dart';
import 'app/app.dart'; // ← Updated import path

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    // Initialize Firebase services
    await FirebaseService.initialize();
    AppLogger.info('Firebase initialized successfully');

    // Initialize dependency injection
    await initializeDependencies();
    AppLogger.info('Dependencies initialized successfully');

    // Log app startup
    await FirebaseService().logEvent('app_started', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    runApp(const MassesSocialApp());
  } catch (e, stackTrace) {
    AppLogger.error('App initialization failed', e, stackTrace);

    // Record error to Firebase if possible
    try {
      await FirebaseService().recordError(e, stackTrace);
    } catch (_) {
      // Silent fail if Firebase not available
    }

    // Run app with error state
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Error: $e'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Restart app
                    main();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
