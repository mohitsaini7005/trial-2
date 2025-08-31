// ignore_for_file: uri_does_not_exist, undefined_class, undefined_identifier, undefined_method
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BillingService {
  BillingService._();
  static final BillingService instance = BillingService._();

  Razorpay? _razorpay;

  Future<void> initStripe({required String publishableKey}) async {
    stripe.Stripe.publishableKey = publishableKey;
    await stripe.Stripe.instance.applySettings();
  }

  Future<void> initRazorpay({required void Function(PaymentSuccessResponse) onSuccess, required void Function(PaymentFailureResponse) onError, required void Function(ExternalWalletResponse) onExternalWallet}) async {
    _razorpay?.clear();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  Future<void> startStripeCheckout({required String customerId, required String ephemeralKey, required String clientSecret}) async {
    try {
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          merchantDisplayName: 'Lali',
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          paymentIntentClientSecret: clientSecret,
          allowsDelayedPaymentMethods: true,
        ),
      );
      await stripe.Stripe.instance.presentPaymentSheet();
    } catch (e, st) {
      log('Stripe checkout error: $e', stackTrace: st);
      rethrow;
    }
  }

  Future<void> startRazorpayCheckout({required String keyId, required int amountPaise, required String currency, required String subscriptionId}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final options = {
      'key': keyId,
      'subscription_id': subscriptionId,
      'amount': amountPaise, // optional for subscriptions
      'currency': currency,
      'prefill': {'email': FirebaseAuth.instance.currentUser?.email ?? ''},
      'notes': {'uid': uid},
    };
    _razorpay?.open(options);
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
