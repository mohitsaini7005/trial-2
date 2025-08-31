import 'package:cloud_firestore/cloud_firestore.dart';

class LoyaltyModel {
  final String id;
  final String userId;
  final int totalPoints;
  final int availablePoints;
  final int usedPoints;
  final int lifetimePoints;
  final LoyaltyTier currentTier;
  final int pointsToNextTier;
  final List<LoyaltyTransaction> transactions;
  final List<String> unlockedBadges;
  final Map<String, dynamic> preferences;
  final DateTime lastUpdated;

  LoyaltyModel({
    required this.id,
    required this.userId,
    this.totalPoints = 0,
    this.availablePoints = 0,
    this.usedPoints = 0,
    this.lifetimePoints = 0,
    this.currentTier = LoyaltyTier.explorer,
    this.pointsToNextTier = 0,
    this.transactions = const [],
    this.unlockedBadges = const [],
    this.preferences = const {},
    required this.lastUpdated,
  });

  factory LoyaltyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return LoyaltyModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      totalPoints: data['totalPoints'] ?? 0,
      availablePoints: data['availablePoints'] ?? 0,
      usedPoints: data['usedPoints'] ?? 0,
      lifetimePoints: data['lifetimePoints'] ?? 0,
      currentTier: LoyaltyTier.values.firstWhere(
        (e) => e.toString() == 'LoyaltyTier.${data['currentTier']}',
        orElse: () => LoyaltyTier.explorer,
      ),
      pointsToNextTier: data['pointsToNextTier'] ?? 0,
      transactions: (data['transactions'] as List<dynamic>?)
          ?.map((transaction) => LoyaltyTransaction.fromMap(transaction))
          .toList() ?? [],
      unlockedBadges: List<String>.from(data['unlockedBadges'] ?? []),
      preferences: data['preferences'] ?? {},
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  double get tierProgress {
    final tierInfo = getTierInfo(currentTier);
    final currentTierPoints = tierInfo['pointsRequired'] as int;
    final nextTierPoints = currentTier == LoyaltyTier.legend 
        ? currentTierPoints 
        : getTierInfo(_getNextTier())['pointsRequired'] as int;
    
    if (currentTier == LoyaltyTier.legend) return 1.0;
    
    final progress = (lifetimePoints - currentTierPoints) / 
                    (nextTierPoints - currentTierPoints);
    return progress.clamp(0.0, 1.0);
  }

  LoyaltyTier _getNextTier() {
    switch (currentTier) {
      case LoyaltyTier.explorer:
        return LoyaltyTier.adventurer;
      case LoyaltyTier.adventurer:
        return LoyaltyTier.pathfinder;
      case LoyaltyTier.pathfinder:
        return LoyaltyTier.legend;
      case LoyaltyTier.legend:
        return LoyaltyTier.legend;
    }
  }

  Map<String, dynamic> getTierInfo(LoyaltyTier tier) {
    switch (tier) {
      case LoyaltyTier.explorer:
        return {
          'name': 'Explorer',
          'pointsRequired': 0,
          'color': '#4CAF50',
          'benefits': ['5% cashback', 'Priority support'],
          'icon': '🌟',
        };
      case LoyaltyTier.adventurer:
        return {
          'name': 'Adventurer',
          'pointsRequired': 500,
          'color': '#2196F3',
          'benefits': ['10% cashback', 'Free trip planning', 'Early access to events'],
          'icon': '🗺️',
        };
      case LoyaltyTier.pathfinder:
        return {
          'name': 'Pathfinder',
          'pointsRequired': 1500,
          'color': '#FF9800',
          'benefits': ['15% cashback', 'Free guided tours', 'VIP event access', 'Personal concierge'],
          'icon': '🎯',
        };
      case LoyaltyTier.legend:
        return {
          'name': 'Legend',
          'pointsRequired': 5000,
          'color': '#9C27B0',
          'benefits': ['20% cashback', 'All-inclusive packages', 'Private experiences', 'Lifetime benefits'],
          'icon': '👑',
        };
    }
  }
}

class LoyaltyTransaction {
  final String id;
  final TransactionType type;
  final int points;
  final String description;
  final String? referenceId; // Trip ID, Order ID, etc.
  final String? referenceType; // 'trip', 'order', 'referral', etc.
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  LoyaltyTransaction({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    this.referenceId,
    this.referenceType,
    required this.timestamp,
    this.metadata = const {},
  });

  factory LoyaltyTransaction.fromMap(Map<String, dynamic> map) {
    return LoyaltyTransaction(
      id: map['id'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${map['type']}',
        orElse: () => TransactionType.earned,
      ),
      points: map['points'] ?? 0,
      description: map['description'] ?? '',
      referenceId: map['referenceId'],
      referenceType: map['referenceType'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      metadata: map['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'points': points,
      'description': description,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'timestamp': Timestamp.fromDate(timestamp),
      'metadata': metadata,
    };
  }
}

class RewardModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final int pointsRequired;
  final RewardType type;
  final RewardCategory category;
  final double? discountPercentage;
  final double? discountAmount;
  final String? productId;
  final String? serviceId;
  final Map<String, dynamic> terms;
  final DateTime validFrom;
  final DateTime validUntil;
  final int availableQuantity;
  final int usedQuantity;
  final bool isActive;
  final bool isFeatured;
  final List<LoyaltyTier> eligibleTiers;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.pointsRequired,
    required this.type,
    required this.category,
    this.discountPercentage,
    this.discountAmount,
    this.productId,
    this.serviceId,
    this.terms = const {},
    required this.validFrom,
    required this.validUntil,
    this.availableQuantity = -1, // -1 means unlimited
    this.usedQuantity = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.eligibleTiers = const [],
  });

  factory RewardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return RewardModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      pointsRequired: data['pointsRequired'] ?? 0,
      type: RewardType.values.firstWhere(
        (e) => e.toString() == 'RewardType.${data['type']}',
        orElse: () => RewardType.discount,
      ),
      category: RewardCategory.values.firstWhere(
        (e) => e.toString() == 'RewardCategory.${data['category']}',
        orElse: () => RewardCategory.travel,
      ),
      discountPercentage: data['discountPercentage']?.toDouble(),
      discountAmount: data['discountAmount']?.toDouble(),
      productId: data['productId'],
      serviceId: data['serviceId'],
      terms: data['terms'] ?? {},
      validFrom: (data['validFrom'] as Timestamp).toDate(),
      validUntil: (data['validUntil'] as Timestamp).toDate(),
      availableQuantity: data['availableQuantity'] ?? -1,
      usedQuantity: data['usedQuantity'] ?? 0,
      isActive: data['isActive'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      eligibleTiers: (data['eligibleTiers'] as List<dynamic>?)
          ?.map((tier) => LoyaltyTier.values.firstWhere(
                (e) => e.toString() == 'LoyaltyTier.$tier',
                orElse: () => LoyaltyTier.explorer,
              ))
          .toList() ?? [],
    );
  }

  bool get isAvailable {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(validFrom) && 
           now.isBefore(validUntil) &&
           (availableQuantity == -1 || usedQuantity < availableQuantity);
  }

  bool isEligibleForTier(LoyaltyTier tier) {
    return eligibleTiers.isEmpty || eligibleTiers.contains(tier);
  }
}

class UserRewardModel {
  final String id;
  final String userId;
  final String rewardId;
  final String rewardTitle;
  final String rewardCode;
  final int pointsUsed;
  final RewardStatus status;
  final DateTime redeemedAt;
  final DateTime? usedAt;
  final DateTime expiresAt;
  final Map<String, dynamic> metadata;

  UserRewardModel({
    required this.id,
    required this.userId,
    required this.rewardId,
    required this.rewardTitle,
    required this.rewardCode,
    required this.pointsUsed,
    this.status = RewardStatus.active,
    required this.redeemedAt,
    this.usedAt,
    required this.expiresAt,
    this.metadata = const {},
  });

  factory UserRewardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserRewardModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      rewardId: data['rewardId'] ?? '',
      rewardTitle: data['rewardTitle'] ?? '',
      rewardCode: data['rewardCode'] ?? '',
      pointsUsed: data['pointsUsed'] ?? 0,
      status: RewardStatus.values.firstWhere(
        (e) => e.toString() == 'RewardStatus.${data['status']}',
        orElse: () => RewardStatus.active,
      ),
      redeemedAt: (data['redeemedAt'] as Timestamp).toDate(),
      usedAt: data['usedAt'] != null ? (data['usedAt'] as Timestamp).toDate() : null,
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      metadata: data['metadata'] ?? {},
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isUsable => status == RewardStatus.active && !isExpired;
}

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String image;
  final BadgeType type;
  final BadgeRarity rarity;
  final Map<String, dynamic> criteria;
  final int pointsReward;
  final bool isHidden;
  final DateTime createdAt;

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.image,
    required this.type,
    required this.rarity,
    this.criteria = const {},
    this.pointsReward = 0,
    this.isHidden = false,
    required this.createdAt,
  });

  factory BadgeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return BadgeModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      image: data['image'] ?? '',
      type: BadgeType.values.firstWhere(
        (e) => e.toString() == 'BadgeType.${data['type']}',
        orElse: () => BadgeType.achievement,
      ),
      rarity: BadgeRarity.values.firstWhere(
        (e) => e.toString() == 'BadgeRarity.${data['rarity']}',
        orElse: () => BadgeRarity.common,
      ),
      criteria: data['criteria'] ?? {},
      pointsReward: data['pointsReward'] ?? 0,
      isHidden: data['isHidden'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

enum LoyaltyTier {
  explorer,    // 0-499 points
  adventurer,  // 500-1499 points  
  pathfinder,  // 1500-4999 points
  legend,      // 5000+ points
}

enum TransactionType {
  earned,      // Points earned
  redeemed,    // Points used for rewards
  expired,     // Points expired
  adjusted,    // Manual adjustment
  bonus,       // Bonus points
}

enum RewardType {
  discount,    // Percentage or amount discount
  freeItem,    // Free product or service
  upgrade,     // Service upgrade
  cashback,    // Cash reward
  experience,  // Special experience
}

enum RewardCategory {
  travel,      // Travel related rewards
  shopping,    // Marketplace rewards
  experiences, // Event/activity rewards
  dining,      // Food related rewards
  wellness,    // Health/wellness rewards
  general,     // General rewards
}

enum RewardStatus {
  active,      // Can be used
  used,        // Already used
  expired,     // Expired
  cancelled,   // Cancelled/revoked
}

enum BadgeType {
  achievement, // Achievement badges
  milestone,   // Milestone badges
  seasonal,    // Time-limited badges
  special,     // Special event badges
}

enum BadgeRarity {
  common,      // Common badges
  rare,        // Rare badges
  epic,        // Epic badges
  legendary,   // Legendary badges
}