import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Creator extends Equatable {
  final String id;
  final String handle;
  final String? displayName;
  final String platform;
  final String? rssUrl;
  final String? activityPubHandle;
  final String? websiteUrl;
  final String? avatarUrl;
  final DateTime? lastFetched;
  final bool isActive;
  final DateTime createdAt;

  const Creator({
    required this.id,
    required this.handle,
    this.displayName,
    required this.platform,
    this.rssUrl,
    this.activityPubHandle,
    this.websiteUrl,
    this.avatarUrl,
    this.lastFetched,
    this.isActive = true,
    required this.createdAt,
  });

  /// Create from Firestore document
  factory Creator.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Creator(
      id: doc.id,
      handle: data['handle'] ?? '',
      displayName: data['displayName'],
      platform: data['platform'] ?? '',
      rssUrl: data['rssUrl'],
      activityPubHandle: data['activityPubHandle'],
      websiteUrl: data['websiteUrl'],
      avatarUrl: data['avatarUrl'],
      lastFetched: (data['lastFetched'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'handle': handle,
      'displayName': displayName,
      'platform': platform,
      'rssUrl': rssUrl,
      'activityPubHandle': activityPubHandle,
      'websiteUrl': websiteUrl,
      'avatarUrl': avatarUrl,
      'lastFetched': lastFetched != null
          ? Timestamp.fromDate(lastFetched!)
          : null,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create copy with updated fields
  Creator copyWith({
    String? id,
    String? handle,
    String? displayName,
    String? platform,
    String? rssUrl,
    String? activityPubHandle,
    String? websiteUrl,
    String? avatarUrl,
    DateTime? lastFetched,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Creator(
      id: id ?? this.id,
      handle: handle ?? this.handle,
      displayName: displayName ?? this.displayName,
      platform: platform ?? this.platform,
      rssUrl: rssUrl ?? this.rssUrl,
      activityPubHandle: activityPubHandle ?? this.activityPubHandle,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastFetched: lastFetched ?? this.lastFetched,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    handle,
    displayName,
    platform,
    rssUrl,
    activityPubHandle,
    websiteUrl,
    avatarUrl,
    lastFetched,
    isActive,
    createdAt,
  ];
}
