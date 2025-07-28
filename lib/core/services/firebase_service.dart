import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../utils/logger.dart';
import '../../firebase_options.dart';

@lazySingleton
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;

  static FirebaseAnalytics get analytics => _analytics!;
  static FirebaseCrashlytics get crashlytics => _crashlytics!;
  static FirebaseAuth get auth => _auth!;
  static FirebaseFirestore get firestore => _firestore!;

  /// Initialize all Firebase services
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize Analytics
      _analytics = FirebaseAnalytics.instance;
      await _analytics!.setAnalyticsCollectionEnabled(!kDebugMode);

      // Initialize Crashlytics
      _crashlytics = FirebaseCrashlytics.instance;
      if (kDebugMode) {
        await _crashlytics!.setCrashlyticsCollectionEnabled(false);
      }

      // Initialize Auth
      _auth = FirebaseAuth.instance;

      // Initialize Firestore
      _firestore = FirebaseFirestore.instance;

      AppLogger.info('Firebase services initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Firebase initialization failed', e, stackTrace);
      rethrow;
    }
  }

  /// Log analytics event
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
    } catch (e) {
      AppLogger.error('Analytics event logging failed', e);
    }
  }

  /// Set user property
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics?.setUserProperty(name: name, value: value);
    } catch (e) {
      AppLogger.error('User property setting failed', e);
    }
  }

  /// Record error
  Future<void> recordError(dynamic exception, StackTrace? stackTrace) async {
    try {
      await _crashlytics?.recordError(exception, stackTrace);
    } catch (e) {
      AppLogger.error('Error recording failed', e);
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth?.currentUser;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => getCurrentUser() != null;
}
