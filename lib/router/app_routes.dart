import 'package:lali/pages/splash.dart';
import 'package:lali/view/forgot_password/forgot.dart';
import 'package:lali/view/login/login.dart';
import 'package:lali/view/reset_password/reset_password.dart';
import 'package:lali/view/signup/signup.dart';
import 'package:get/get.dart';
import 'package:lali/pages/settings.dart';
import 'package:lali/pages/legal_privacy.dart';
import 'package:lali/pages/legal_terms.dart';
import 'package:lali/pages/event_details.dart';
import 'package:lali/pages/event_checkout.dart';
import 'package:lali/pages/bookings.dart';
import 'package:lali/pages/tribal_stays/tribal_stays_page.dart';
import 'package:lali/pages/food_accommodation/food_accommodation_page.dart';
import 'package:lali/pages/marketplace/marketplace_page.dart';
import 'package:lali/pages/blogs/blogs_page.dart';
import 'package:lali/pages/profile/profile_page.dart';
import 'package:lali/home.dart';

class AppRoutes {
  static String login = '/login';

  static String signup = '/signup';

  static String reset = '/reset';

  static String forgot = '/forgot';

  static String onBoarding = '/onBoarding';

  static String settings = '/settings';
  static String privacy = '/privacy';
  static String terms = '/terms';
  static String events = '/events';
  static String eventDetails = '/eventDetails';
  static String eventCheckout = '/eventCheckout';
  static String bookings = '/bookings';
  static String tribalStays = '/tribalStays';
  static String foodAccommodation = '/foodAccommodation';
  static String marketplace = '/marketplace';
  static String blogs = '/blogs';
  static String profile = '/profile';
  static String home = '/';

  static List<GetPage> pages = [
    GetPage(
      name: login,
      page: () => const Login(),
    ),
    GetPage(
      name: signup,
      page: () => const SignUp(),
    ),
    GetPage(
      name: forgot,
      page: () => const ForgotPassword(),
    ),
    GetPage(
      name: reset,
      page: () => const ResetPassword(),
    ),
    GetPage(
      name: onBoarding,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsPage(),
    ),
    GetPage(
      name: privacy,
      page: () => const PrivacyPolicyPage(),
    ),
    GetPage(
      name: terms,
      page: () => const TermsPage(),
    ),
    GetPage(
      name: eventDetails,
      page: () => const EventDetailsPage(),
    ),
    GetPage(
      name: eventCheckout,
      page: () => const EventCheckoutPage(),
    ),
    GetPage(
      name: bookings,
      page: () => const BookingsPage(),
    ),
    GetPage(
      name: tribalStays,
      page: () => const TribalStaysPage(),
    ),
    GetPage(
      name: foodAccommodation,
      page: () => const FoodAccommodationPage(),
    ),
    GetPage(
      name: marketplace,
      page: () => const MarketplacePage(),
    ),
    GetPage(
      name: blogs,
      page: () => const BlogsPage(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfilePage(),
    ),
    GetPage(
      name: home,
      page: () => const Home(),
    ),
  ];
}
