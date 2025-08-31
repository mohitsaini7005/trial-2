import 'package:cloud_firestore/cloud_firestore.dart';

class SocialPostModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String title;
  final String description;
  final List<String> mediaUrls;
  final PostType type;
  final String? locationName;
  final GeoPoint? location;
  final List<String> tags;
  final List<String> mentions;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isPublic;
  final bool isPromoted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> likedBy;
  final String? tripId; // Link to trip/place if applicable
  final String? eventId; // Link to event if applicable
  final String? productId; // Link to product if applicable

  SocialPostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.title,
    required this.description,
    required this.mediaUrls,
    required this.type,
    this.locationName,
    this.location,
    this.tags = const [],
    this.mentions = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.isPublic = true,
    this.isPromoted = false,
    required this.createdAt,
    required this.updatedAt,
    this.likedBy = const [],
    this.tripId,
    this.eventId,
    this.productId,
  });

  factory SocialPostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return SocialPostModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatar: data['userAvatar'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
      type: PostType.values.firstWhere(
        (e) => e.toString() == 'PostType.${data['type']}',
        orElse: () => PostType.story,
      ),
      locationName: data['locationName'],
      location: data['location'] as GeoPoint?,
      tags: List<String>.from(data['tags'] ?? []),
      mentions: List<String>.from(data['mentions'] ?? []),
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      sharesCount: data['sharesCount'] ?? 0,
      viewsCount: data['viewsCount'] ?? 0,
      isPublic: data['isPublic'] ?? true,
      isPromoted: data['isPromoted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      likedBy: List<String>.from(data['likedBy'] ?? []),
      tripId: data['tripId'],
      eventId: data['eventId'],
      productId: data['productId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'title': title,
      'description': description,
      'mediaUrls': mediaUrls,
      'type': type.toString().split('.').last,
      'locationName': locationName,
      'location': location,
      'tags': tags,
      'mentions': mentions,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'isPublic': isPublic,
      'isPromoted': isPromoted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'likedBy': likedBy,
      'tripId': tripId,
      'eventId': eventId,
      'productId': productId,
    };
  }

  bool isLikedBy(String userId) => likedBy.contains(userId);
  bool get hasMedia => mediaUrls.isNotEmpty;
  bool get isVideo => mediaUrls.any((url) => url.contains('.mp4') || url.contains('.mov'));
  String get primaryMediaUrl => mediaUrls.isNotEmpty ? mediaUrls.first : '';
}

class SocialCommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final int likesCount;
  final List<String> likedBy;
  final DateTime createdAt;
  final String? parentCommentId; // For replies
  final List<String> mentions;

  SocialCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.likesCount = 0,
    this.likedBy = const [],
    required this.createdAt,
    this.parentCommentId,
    this.mentions = const [],
  });

  factory SocialCommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return SocialCommentModel(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatar: data['userAvatar'] ?? '',
      content: data['content'] ?? '',
      likesCount: data['likesCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      parentCommentId: data['parentCommentId'],
      mentions: List<String>.from(data['mentions'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'likesCount': likesCount,
      'likedBy': likedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'parentCommentId': parentCommentId,
      'mentions': mentions,
    };
  }

  bool isLikedBy(String userId) => likedBy.contains(userId);
  bool get isReply => parentCommentId != null;
}

class UserProfileModel {
  final String id;
  final String email;
  final String displayName;
  final String? avatar;
  final String? bio;
  final String? location;
  final String? website;
  final DateTime joinedAt;
  final DateTime lastActiveAt;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final List<String> interests;
  final Map<String, dynamic> preferences;
  final bool isVerified;
  final bool isInfluencer;
  final bool isGuide;
  final bool isSeller;
  final UserLevel level;
  final int loyaltyPoints;
  final List<String> badges;
  final UserStats stats;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatar,
    this.bio,
    this.location,
    this.website,
    required this.joinedAt,
    required this.lastActiveAt,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.interests = const [],
    this.preferences = const {},
    this.isVerified = false,
    this.isInfluencer = false,
    this.isGuide = false,
    this.isSeller = false,
    this.level = UserLevel.explorer,
    this.loyaltyPoints = 0,
    this.badges = const [],
    required this.stats,
  });

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserProfileModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      avatar: data['avatar'],
      bio: data['bio'],
      location: data['location'],
      website: data['website'],
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      lastActiveAt: (data['lastActiveAt'] as Timestamp).toDate(),
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      postsCount: data['postsCount'] ?? 0,
      interests: List<String>.from(data['interests'] ?? []),
      preferences: data['preferences'] ?? {},
      isVerified: data['isVerified'] ?? false,
      isInfluencer: data['isInfluencer'] ?? false,
      isGuide: data['isGuide'] ?? false,
      isSeller: data['isSeller'] ?? false,
      level: UserLevel.values.firstWhere(
        (e) => e.toString() == 'UserLevel.${data['level']}',
        orElse: () => UserLevel.explorer,
      ),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      badges: List<String>.from(data['badges'] ?? []),
      stats: UserStats.fromMap(data['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'avatar': avatar,
      'bio': bio,
      'location': location,
      'website': website,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'lastActiveAt': Timestamp.fromDate(lastActiveAt),
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'interests': interests,
      'preferences': preferences,
      'isVerified': isVerified,
      'isInfluencer': isInfluencer,
      'isGuide': isGuide,
      'isSeller': isSeller,
      'level': level.toString().split('.').last,
      'loyaltyPoints': loyaltyPoints,
      'badges': badges,
      'stats': stats.toMap(),
    };
  }
}

class UserStats {
  final int totalTrips;
  final int totalSpent;
  final int totalReviews;
  final double averageRating;
  final int totalBookings;
  final int cancelledBookings;

  UserStats({
    this.totalTrips = 0,
    this.totalSpent = 0,
    this.totalReviews = 0,
    this.averageRating = 0.0,
    this.totalBookings = 0,
    this.cancelledBookings = 0,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalTrips: map['totalTrips'] ?? 0,
      totalSpent: map['totalSpent'] ?? 0,
      totalReviews: map['totalReviews'] ?? 0,
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      totalBookings: map['totalBookings'] ?? 0,
      cancelledBookings: map['cancelledBookings'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalTrips': totalTrips,
      'totalSpent': totalSpent,
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'totalBookings': totalBookings,
      'cancelledBookings': cancelledBookings,
    };
  }
}

enum PostType {
  story,      // Text + single image
  reel,       // Short video
  photo,      // Multiple photos
  blog,       // Long-form content
  experience, // Trip experience
  review,     // Product/place review
}

enum UserLevel {
  explorer,   // 0-100 points
  adventurer, // 101-500 points
  pathfinder, // 501-1000 points
  legend,     // 1001+ points
}