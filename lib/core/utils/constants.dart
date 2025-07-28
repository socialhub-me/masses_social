class AppConstants {
  // App Information
  static const String appName = 'Masses Social';
  static const String appVersion = '1.0.0';

  // RSS Configuration
  static const Duration rssFetchTimeout = Duration(seconds: 30);
  static const Duration rssCacheExpiry = Duration(hours: 4);
  static const int maxRSSItems = 50;

  // Platform Types
  static const String platformYouTube = 'YouTube';
  static const String platformMastodon = 'Mastodon';
  static const String platformBlog = 'Blog';
  static const String platformPodcast = 'Podcast';

  static const List<String> supportedPlatforms = [
    platformYouTube,
    platformMastodon,
    platformBlog,
    platformPodcast,
  ];

  // Content Types
  static const String contentTypeVideo = 'video';
  static const String contentTypePost = 'post';
  static const String contentTypePodcast = 'podcast';
  static const String contentTypeArticle = 'article';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String creatorsCollection = 'creators';
  static const String contentCollection = 'content_notifications';
  static const String userFollowsCollection = 'user_follows';

  // Analytics Events
  static const String eventAppStarted = 'app_started';
  static const String eventUserSignedIn = 'user_signed_in';
  static const String eventCreatorAdded = 'creator_added';
  static const String eventContentViewed = 'content_viewed';
  static const String eventRSSFetched = 'rss_fetched';
}
