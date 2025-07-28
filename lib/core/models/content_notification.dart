import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContentNotification extends Equatable {
  final String id;
  final String creatorId;
  final String creatorHandle;
  final String creatorDisplayName;
  final String title;
  final String contentUrl;
  final String description;
  final String? thumbnailUrl;
  final DateTime publishedAt;
  final String platform;
  final String contentType;
  final bool isRead;
  final bool isSaved;
  final DateTime createdAt;

  const ContentNotification({
    required this.id,
    required this.creatorId,
    required this.creatorHandle,
    required this.creatorDisplayName,
    required this.title,
    required this.contentUrl,
    required this.description,
    this.thumbnailUrl,
    required this.publishedAt,
    required this.platform,
    required this.contentType,
    required this.isRead,
    required this.isSaved,
    required this.createdAt,
  });

  /// Create from Firestore document
  factory ContentNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ContentNotification(
      id: doc.id,
      creatorId: data['creatorId'] ?? '',
      creatorHandle: data['creatorHandle'] ?? '',
      creatorDisplayName: data['creatorDisplayName'] ?? '',
      title: data['title'] ?? '',
      contentUrl: data['contentUrl'] ?? '',
      description: data['description'] ?? '',
      thumbnailUrl: data['thumbnailUrl'],
      publishedAt:
          (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      platform: data['platform'] ?? '',
      contentType: data['contentType'] ?? 'post',
      isRead: data['isRead'] ?? false,
      isSaved: data['isSaved'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'creatorId': creatorId,
      'creatorHandle': creatorHandle,
      'creatorDisplayName': creatorDisplayName,
      'title': title,
      'contentUrl': contentUrl,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'platform': platform,
      'contentType': contentType,
      'isRead': isRead,
      'isSaved': isSaved,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create copy with updated fields
  ContentNotification copyWith({
    String? id,
    String? creatorId,
    String? creatorHandle,
    String? creatorDisplayName,
    String? title,
    String? contentUrl,
    String? description,
    String? thumbnailUrl,
    DateTime? publishedAt,
    String? platform,
    String? contentType,
    bool? isRead,
    bool? isSaved,
    DateTime? createdAt,
  }) {
    return ContentNotification(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      creatorHandle: creatorHandle ?? this.creatorHandle,
      creatorDisplayName: creatorDisplayName ?? this.creatorDisplayName,
      title: title ?? this.title,
      contentUrl: contentUrl ?? this.contentUrl,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      platform: platform ?? this.platform,
      contentType: contentType ?? this.contentType,
      isRead: isRead ?? this.isRead,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    creatorId,
    creatorHandle,
    creatorDisplayName,
    title,
    contentUrl,
    description,
    thumbnailUrl,
    publishedAt,
    platform,
    contentType,
    isRead,
    isSaved,
    createdAt,
  ];
}
