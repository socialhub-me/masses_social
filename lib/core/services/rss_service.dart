import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:injectable/injectable.dart';
import '../models/content_notification.dart';
import '../models/creator.dart';
import '../utils/logger.dart';
import '../errors/exceptions.dart';

@lazySingleton
class RSSService {
  final http.Client _httpClient;

  RSSService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// Fetch and parse RSS feed for a creator
  Future<List<ContentNotification>> fetchCreatorFeed(Creator creator) async {
    if (creator.rssUrl == null || creator.rssUrl!.isEmpty) {
      throw RSSException('Creator ${creator.handle} has no RSS URL');
    }

    try {
      AppLogger.info('Fetching RSS feed for ${creator.handle}');

      final response = await _httpClient
          .get(
            Uri.parse(creator.rssUrl!),
            headers: {
              'User-Agent': 'Masses Social Aggregator 1.0',
              'Accept': 'application/rss+xml, application/xml, text/xml',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw RSSException('RSS fetch timeout for ${creator.handle}'),
          );

      if (response.statusCode != 200) {
        throw RSSException('HTTP ${response.statusCode} for ${creator.handle}');
      }

      return _parseRSSFeed(response.body, creator);
    } catch (e) {
      AppLogger.error('RSS fetch failed for ${creator.handle}', e);
      if (e is RSSException) rethrow;
      throw RSSException('RSS fetch failed for ${creator.handle}: $e');
    }
  }

  /// Parse RSS XML content into ContentNotification objects
  List<ContentNotification> _parseRSSFeed(String xmlContent, Creator creator) {
    try {
      final document = XmlDocument.parse(xmlContent);
      final notifications = <ContentNotification>[];

      // Parse Atom feeds (YouTube uses this format)
      final atomEntries = document.findAllElements('entry');
      for (final entry in atomEntries) {
        final notification = _parseAtomEntry(entry, creator);
        if (notification != null) {
          notifications.add(notification);
        }
      }

      // Parse RSS 2.0 feeds
      final rssItems = document.findAllElements('item');
      for (final item in rssItems) {
        final notification = _parseRSSItem(item, creator);
        if (notification != null) {
          notifications.add(notification);
        }
      }

      AppLogger.info(
        'Parsed ${notifications.length} items for ${creator.handle}',
      );
      return notifications;
    } catch (e) {
      AppLogger.error('RSS parsing failed for ${creator.handle}', e);
      throw RSSException('RSS parsing failed for ${creator.handle}: $e');
    }
  }

  /// Parse Atom entry (YouTube format)
  ContentNotification? _parseAtomEntry(XmlElement entry, Creator creator) {
    try {
      final title =
          entry.findElements('title').firstOrNull?.innerText ?? 'Untitled';
      final linkElement = entry.findElements('link').firstOrNull;
      final contentUrl = linkElement?.getAttribute('href') ?? '';

      if (contentUrl.isEmpty) return null;

      final published =
          entry.findElements('published').firstOrNull?.innerText ??
          entry.findElements('updated').firstOrNull?.innerText ??
          '';

      final summary =
          entry.findElements('summary').firstOrNull?.innerText ??
          entry.findElements('content').firstOrNull?.innerText ??
          '';

      // Extract thumbnail from media:thumbnail
      String? thumbnailUrl;
      final mediaThumbnail = entry.findElements('media:thumbnail').firstOrNull;
      if (mediaThumbnail != null) {
        thumbnailUrl = mediaThumbnail.getAttribute('url');
      }

      return ContentNotification(
        id: '', // Will be set when stored in database
        creatorId: creator.id,
        creatorHandle: creator.handle,
        creatorDisplayName: creator.displayName ?? creator.handle,
        title: title,
        contentUrl: contentUrl,
        description: _stripHtml(summary),
        thumbnailUrl: thumbnailUrl,
        publishedAt: _parseDateTime(published),
        platform: creator.platform,
        contentType: _detectContentType(contentUrl, creator.platform),
        isRead: false,
        isSaved: false,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      AppLogger.error('Error parsing Atom entry', e);
      return null;
    }
  }

  /// Parse RSS item (standard RSS 2.0 format)
  ContentNotification? _parseRSSItem(XmlElement item, Creator creator) {
    try {
      final title =
          item.findElements('title').firstOrNull?.innerText ?? 'Untitled';
      final contentUrl = item.findElements('link').firstOrNull?.innerText ?? '';

      if (contentUrl.isEmpty) return null;

      final pubDate = item.findElements('pubDate').firstOrNull?.innerText ?? '';
      final description =
          item.findElements('description').firstOrNull?.innerText ?? '';

      // Extract thumbnail from enclosure or media:content
      String? thumbnailUrl;
      final enclosure = item.findElements('enclosure').firstOrNull;
      if (enclosure != null &&
          enclosure.getAttribute('type')?.startsWith('image/') == true) {
        thumbnailUrl = enclosure.getAttribute('url');
      }

      return ContentNotification(
        id: '',
        creatorId: creator.id,
        creatorHandle: creator.handle,
        creatorDisplayName: creator.displayName ?? creator.handle,
        title: title,
        contentUrl: contentUrl,
        description: _stripHtml(description),
        thumbnailUrl: thumbnailUrl,
        publishedAt: _parseDateTime(pubDate),
        platform: creator.platform,
        contentType: _detectContentType(contentUrl, creator.platform),
        isRead: false,
        isSaved: false,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      AppLogger.error('Error parsing RSS item', e);
      return null;
    }
  }

  /// Generate YouTube RSS URL from channel ID
  static String getYouTubeRSSUrl(String channelId) {
    if (channelId.startsWith('UC') && channelId.length == 24) {
      return 'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';
    }
    return 'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';
  }

  /// Utility methods
  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  DateTime _parseDateTime(String dateString) {
    if (dateString.isEmpty) return DateTime.now();
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      // Try parsing RFC 2822 format (common in RSS)
      try {
        return http.parseHttpDate(dateString) ?? DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }
  }

  String _detectContentType(String url, String platform) {
    if (platform.toLowerCase() == 'youtube') return 'video';
    if (url.contains('podcast') || url.contains('audio')) return 'podcast';
    return 'post';
  }

  void dispose() {
    _httpClient.close();
  }
}
