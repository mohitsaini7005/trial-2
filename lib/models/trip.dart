import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  final String id;
  final String title;
  final String description;
  final String shortDescription;
  final List<String> images;
  final String destination;
  final String state;
  final String tribalRegion;
  final double basePrice;
  final double discountPrice;
  final int duration; // in days
  final TripType type;
  final DifficultyLevel difficulty;
  final List<String> inclusions;
  final List<String> exclusions;
  final List<String> highlights;
  final String itinerary; // JSON string or detailed description
  final double rating;
  final int reviewCount;
  final String guideId;
  final String guideName;
  final String guideAvatar;
  final bool isGuideVerified;
  final int maxGroupSize;
  final int availableSlots;
  final List<DateTime> availableDates;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isFeatured;
  final List<String> tags;
  final Map<String, dynamic> location; // lat, lng, address
  final List<TripActivity> activities;
  final CancellationPolicy cancellationPolicy;

  TripModel({
    required this.id,
    required this.title,
    required this.description,
    required this.shortDescription,
    required this.images,
    required this.destination,
    required this.state,
    required this.tribalRegion,
    required this.basePrice,
    this.discountPrice = 0,
    required this.duration,
    required this.type,
    required this.difficulty,
    this.inclusions = const [],
    this.exclusions = const [],
    this.highlights = const [],
    required this.itinerary,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.guideId,
    required this.guideName,
    required this.guideAvatar,
    this.isGuideVerified = false,
    required this.maxGroupSize,
    required this.availableSlots,
    this.availableDates = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.isFeatured = false,
    this.tags = const [],
    this.location = const {},
    this.activities = const [],
    this.cancellationPolicy = CancellationPolicy.moderate,
  });

  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return TripModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      destination: data['destination'] ?? '',
      state: data['state'] ?? '',
      tribalRegion: data['tribalRegion'] ?? '',
      basePrice: (data['basePrice'] ?? 0).toDouble(),
      discountPrice: (data['discountPrice'] ?? 0).toDouble(),
      duration: data['duration'] ?? 1,
      type: TripType.values.firstWhere(
        (e) => e.toString() == 'TripType.${data['type']}',
        orElse: () => TripType.cultural,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.toString() == 'DifficultyLevel.${data['difficulty']}',
        orElse: () => DifficultyLevel.easy,
      ),
      inclusions: List<String>.from(data['inclusions'] ?? []),
      exclusions: List<String>.from(data['exclusions'] ?? []),
      highlights: List<String>.from(data['highlights'] ?? []),
      itinerary: data['itinerary'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      guideId: data['guideId'] ?? '',
      guideName: data['guideName'] ?? '',
      guideAvatar: data['guideAvatar'] ?? '',
      isGuideVerified: data['isGuideVerified'] ?? false,
      maxGroupSize: data['maxGroupSize'] ?? 10,
      availableSlots: data['availableSlots'] ?? 0,
      availableDates: (data['availableDates'] as List<dynamic>?)
          ?.map((date) => (date as Timestamp).toDate())
          .toList() ?? [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      location: data['location'] ?? {},
      activities: (data['activities'] as List<dynamic>?)
          ?.map((activity) => TripActivity.fromMap(activity))
          .toList() ?? [],
      cancellationPolicy: CancellationPolicy.values.firstWhere(
        (e) => e.toString() == 'CancellationPolicy.${data['cancellationPolicy']}',
        orElse: () => CancellationPolicy.moderate,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'shortDescription': shortDescription,
      'images': images,
      'destination': destination,
      'state': state,
      'tribalRegion': tribalRegion,
      'basePrice': basePrice,
      'discountPrice': discountPrice,
      'duration': duration,
      'type': type.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'inclusions': inclusions,
      'exclusions': exclusions,
      'highlights': highlights,
      'itinerary': itinerary,
      'rating': rating,
      'reviewCount': reviewCount,
      'guideId': guideId,
      'guideName': guideName,
      'guideAvatar': guideAvatar,
      'isGuideVerified': isGuideVerified,
      'maxGroupSize': maxGroupSize,
      'availableSlots': availableSlots,
      'availableDates': availableDates.map((date) => Timestamp.fromDate(date)).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'isFeatured': isFeatured,
      'tags': tags,
      'location': location,
      'activities': activities.map((activity) => activity.toMap()).toList(),
      'cancellationPolicy': cancellationPolicy.toString().split('.').last,
    };
  }

  double get finalPrice => discountPrice > 0 ? discountPrice : basePrice;
  double get discountPercentage => 
      discountPrice > 0 ? ((basePrice - discountPrice) / basePrice * 100) : 0;
  bool get hasDiscount => discountPrice > 0 && discountPrice < basePrice;
  bool get isAvailable => availableSlots > 0 && isActive;
  String get priceRange => duration > 1 ? '₹${finalPrice.toStringAsFixed(0)}/person' : '₹${finalPrice.toStringAsFixed(0)}';
}

class TripActivity {
  final String id;
  final String name;
  final String description;
  final int dayNumber;
  final String timeSlot;
  final bool isIncluded;
  final double additionalCost;

  TripActivity({
    required this.id,
    required this.name,
    required this.description,
    required this.dayNumber,
    required this.timeSlot,
    this.isIncluded = true,
    this.additionalCost = 0,
  });

  factory TripActivity.fromMap(Map<String, dynamic> map) {
    return TripActivity(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      dayNumber: map['dayNumber'] ?? 1,
      timeSlot: map['timeSlot'] ?? '',
      isIncluded: map['isIncluded'] ?? true,
      additionalCost: (map['additionalCost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dayNumber': dayNumber,
      'timeSlot': timeSlot,
      'isIncluded': isIncluded,
      'additionalCost': additionalCost,
    };
  }
}

class TripBookingModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String tripId;
  final String tripTitle;
  final String tripImage;
  final DateTime bookingDate;
  final DateTime travelDate;
  final int numberOfTravelers;
  final List<TravelerInfo> travelers;
  final double totalAmount;
  final double paidAmount;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentId;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BookingStatusUpdate> statusHistory;
  final Map<String, dynamic> additionalServices;
  final String? specialRequests;
  final EmergencyContact emergencyContact;

  TripBookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.tripId,
    required this.tripTitle,
    required this.tripImage,
    required this.bookingDate,
    required this.travelDate,
    required this.numberOfTravelers,
    required this.travelers,
    required this.totalAmount,
    this.paidAmount = 0,
    this.status = BookingStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentId,
    this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    this.statusHistory = const [],
    this.additionalServices = const {},
    this.specialRequests,
    required this.emergencyContact,
  });

  factory TripBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return TripBookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userPhone: data['userPhone'] ?? '',
      tripId: data['tripId'] ?? '',
      tripTitle: data['tripTitle'] ?? '',
      tripImage: data['tripImage'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      travelDate: (data['travelDate'] as Timestamp).toDate(),
      numberOfTravelers: data['numberOfTravelers'] ?? 1,
      travelers: (data['travelers'] as List<dynamic>?)
          ?.map((traveler) => TravelerInfo.fromMap(traveler))
          .toList() ?? [],
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      paidAmount: (data['paidAmount'] ?? 0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${data['status']}',
        orElse: () => BookingStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${data['paymentStatus']}',
        orElse: () => PaymentStatus.pending,
      ),
      paymentId: data['paymentId'],
      paymentMethod: data['paymentMethod'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      statusHistory: (data['statusHistory'] as List<dynamic>?)
          ?.map((history) => BookingStatusUpdate.fromMap(history))
          .toList() ?? [],
      additionalServices: data['additionalServices'] ?? {},
      specialRequests: data['specialRequests'],
      emergencyContact: EmergencyContact.fromMap(data['emergencyContact'] ?? {}),
    );
  }

  double get remainingAmount => totalAmount - paidAmount;
  bool get isFullyPaid => paidAmount >= totalAmount;
  bool get canCancel => [BookingStatus.pending, BookingStatus.confirmed].contains(status);
}

class TravelerInfo {
  final String name;
  final int age;
  final String gender;
  final String? idType;
  final String? idNumber;
  final String? dietaryRestrictions;
  final String? medicalConditions;

  TravelerInfo({
    required this.name,
    required this.age,
    required this.gender,
    this.idType,
    this.idNumber,
    this.dietaryRestrictions,
    this.medicalConditions,
  });

  factory TravelerInfo.fromMap(Map<String, dynamic> map) {
    return TravelerInfo(
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      idType: map['idType'],
      idNumber: map['idNumber'],
      dietaryRestrictions: map['dietaryRestrictions'],
      medicalConditions: map['medicalConditions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'idType': idType,
      'idNumber': idNumber,
      'dietaryRestrictions': dietaryRestrictions,
      'medicalConditions': medicalConditions,
    };
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relationship;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relationship,
  });

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      relationship: map['relationship'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'relationship': relationship,
    };
  }
}

class BookingStatusUpdate {
  final BookingStatus status;
  final String message;
  final DateTime timestamp;
  final String? updatedBy;

  BookingStatusUpdate({
    required this.status,
    required this.message,
    required this.timestamp,
    this.updatedBy,
  });

  factory BookingStatusUpdate.fromMap(Map<String, dynamic> map) {
    return BookingStatusUpdate(
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${map['status']}',
        orElse: () => BookingStatus.pending,
      ),
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      updatedBy: map['updatedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.toString().split('.').last,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'updatedBy': updatedBy,
    };
  }
}

enum TripType {
  cultural,      // Cultural immersion
  adventure,     // Adventure activities
  spiritual,     // Spiritual experiences
  educational,   // Learning focused
  photography,   // Photography tours
  festival,      // Festival experiences
  wellness,      // Wellness retreats
  homestay,      // Village stays
}

enum DifficultyLevel {
  easy,          // Easy for all ages
  moderate,      // Moderate fitness required
  challenging,   // Good fitness required
  expert,        // High fitness required
}

enum BookingStatus {
  pending,       // Awaiting confirmation
  confirmed,     // Booking confirmed
  cancelled,     // Cancelled by user
  completed,     // Trip completed
  refunded,      // Money refunded
  noShow,        // User didn't show up
}

enum PaymentStatus {
  pending,       // Payment pending
  partial,       // Partially paid
  completed,     // Fully paid
  failed,        // Payment failed
  refunded,      // Refunded
}

enum CancellationPolicy {
  flexible,      // Full refund up to 24 hours before
  moderate,      // 50% refund up to 48 hours before
  strict,        // No refund within 7 days
  nonRefundable, // No refund at all
}