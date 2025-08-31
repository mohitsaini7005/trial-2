import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final double shippingCost;
  final double taxAmount;
  final double discountAmount;
  final String? couponCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    this.totalAmount = 0,
    this.shippingCost = 0,
    this.taxAmount = 0,
    this.discountAmount = 0,
    this.couponCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return CartModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromMap(item))
          .toList() ?? [],
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      shippingCost: (data['shippingCost'] ?? 0).toDouble(),
      taxAmount: (data['taxAmount'] ?? 0).toDouble(),
      discountAmount: (data['discountAmount'] ?? 0).toDouble(),
      couponCode: data['couponCode'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'shippingCost': shippingCost,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'couponCode': couponCode,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  double get grandTotal => totalAmount + shippingCost + taxAmount - discountAmount;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}

class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String? variantId;
  final String? variantName;
  final Map<String, dynamic> productData;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.variantId,
    this.variantName,
    this.productData = const {},
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      variantId: map['variantId'],
      variantName: map['variantName'],
      productData: map['productData'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'variantId': variantId,
      'variantName': variantName,
      'productData': productData,
    };
  }

  double get subtotal => price * quantity;
}

class OrderModel {
  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final List<OrderItem> items;
  final double totalAmount;
  final double shippingCost;
  final double taxAmount;
  final double discountAmount;
  final String? couponCode;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentId;
  final String? paymentMethod;
  final ShippingAddress shippingAddress;
  final ShippingAddress? billingAddress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderStatusUpdate> statusHistory;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.items,
    this.totalAmount = 0,
    this.shippingCost = 0,
    this.taxAmount = 0,
    this.discountAmount = 0,
    this.couponCode,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentId,
    this.paymentMethod,
    required this.shippingAddress,
    this.billingAddress,
    required this.createdAt,
    required this.updatedAt,
    this.statusHistory = const [],
    this.trackingNumber,
    this.estimatedDelivery,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? '',
      items: (data['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item))
          .toList() ?? [],
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      shippingCost: (data['shippingCost'] ?? 0).toDouble(),
      taxAmount: (data['taxAmount'] ?? 0).toDouble(),
      discountAmount: (data['discountAmount'] ?? 0).toDouble(),
      couponCode: data['couponCode'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${data['status']}',
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${data['paymentStatus']}',
        orElse: () => PaymentStatus.pending,
      ),
      paymentId: data['paymentId'],
      paymentMethod: data['paymentMethod'],
      shippingAddress: ShippingAddress.fromMap(data['shippingAddress']),
      billingAddress: data['billingAddress'] != null 
          ? ShippingAddress.fromMap(data['billingAddress']) 
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      statusHistory: (data['statusHistory'] as List<dynamic>?)
          ?.map((history) => OrderStatusUpdate.fromMap(history))
          .toList() ?? [],
      trackingNumber: data['trackingNumber'],
      estimatedDelivery: data['estimatedDelivery'] != null 
          ? (data['estimatedDelivery'] as Timestamp).toDate() 
          : null,
    );
  }

  double get grandTotal => totalAmount + shippingCost + taxAmount - discountAmount;
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String? variantId;
  final String? variantName;
  final String sellerId;
  final String sellerName;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.variantId,
    this.variantName,
    required this.sellerId,
    required this.sellerName,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      variantId: map['variantId'],
      variantName: map['variantName'],
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'variantId': variantId,
      'variantName': variantName,
      'sellerId': sellerId,
      'sellerName': sellerName,
    };
  }

  double get subtotal => price * quantity;
}

class ShippingAddress {
  final String fullName;
  final String phoneNumber;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String country;
  final bool isDefault;

  ShippingAddress({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    this.country = 'India',
    this.isDefault = false,
  });

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pinCode: map['pinCode'] ?? '',
      country: map['country'] ?? 'India',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'country': country,
      'isDefault': isDefault,
    };
  }
}

class OrderStatusUpdate {
  final OrderStatus status;
  final String message;
  final DateTime timestamp;

  OrderStatusUpdate({
    required this.status,
    required this.message,
    required this.timestamp,
  });

  factory OrderStatusUpdate.fromMap(Map<String, dynamic> map) {
    return OrderStatusUpdate(
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${map['status']}',
        orElse: () => OrderStatus.pending,
      ),
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.toString().split('.').last,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned,
  refunded
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded
}