import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountPrice;
  final List<String> images;
  final String category;
  final String subcategory;
  final String sellerId;
  final String sellerName;
  final String tribalOrigin;
  final Map<String, dynamic> specifications;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final int stockQuantity;
  final bool isHandmade;
  final bool isCertified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> shippingInfo;
  final List<ProductVariant> variants;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice = 0,
    required this.images,
    required this.category,
    required this.subcategory,
    required this.sellerId,
    required this.sellerName,
    required this.tribalOrigin,
    this.specifications = const {},
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stockQuantity = 0,
    this.isHandmade = false,
    this.isCertified = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.shippingInfo = const {},
    this.variants = const [],
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discountPrice: (data['discountPrice'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      category: data['category'] ?? '',
      subcategory: data['subcategory'] ?? '',
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      tribalOrigin: data['tribalOrigin'] ?? '',
      specifications: data['specifications'] ?? {},
      tags: List<String>.from(data['tags'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      stockQuantity: data['stockQuantity'] ?? 0,
      isHandmade: data['isHandmade'] ?? false,
      isCertified: data['isCertified'] ?? false,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      shippingInfo: data['shippingInfo'] ?? {},
      variants: (data['variants'] as List<dynamic>?)
          ?.map((v) => ProductVariant.fromMap(v))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'images': images,
      'category': category,
      'subcategory': subcategory,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'tribalOrigin': tribalOrigin,
      'specifications': specifications,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'stockQuantity': stockQuantity,
      'isHandmade': isHandmade,
      'isCertified': isCertified,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'shippingInfo': shippingInfo,
      'variants': variants.map((v) => v.toMap()).toList(),
    };
  }

  double get finalPrice => discountPrice > 0 ? discountPrice : price;
  double get discountPercentage => 
      discountPrice > 0 ? ((price - discountPrice) / price * 100) : 0;
  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
  bool get isInStock => stockQuantity > 0;
}

class ProductVariant {
  final String id;
  final String name;
  final double priceModifier;
  final int stockQuantity;
  final Map<String, String> attributes; // e.g., {"size": "Large", "color": "Red"}

  ProductVariant({
    required this.id,
    required this.name,
    this.priceModifier = 0,
    this.stockQuantity = 0,
    this.attributes = const {},
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      priceModifier: (map['priceModifier'] ?? 0).toDouble(),
      stockQuantity: map['stockQuantity'] ?? 0,
      attributes: Map<String, String>.from(map['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priceModifier': priceModifier,
      'stockQuantity': stockQuantity,
      'attributes': attributes,
    };
  }
}

class ProductCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String image;
  final bool isActive;
  final int sortOrder;

  ProductCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.image,
    this.isActive = true,
    this.sortOrder = 0,
  });

  factory ProductCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ProductCategory(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      image: data['image'] ?? '',
      isActive: data['isActive'] ?? true,
      sortOrder: data['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'image': image,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}