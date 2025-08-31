import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lali/blocs/blog_bloc.dart';
import 'package:lali/blocs/bookmark_bloc.dart';
import 'package:lali/blocs/comments_bloc.dart';
import 'package:lali/blocs/featured_bloc.dart';
import 'package:lali/blocs/internet_bloc.dart';
import 'package:lali/blocs/notification_bloc.dart';
import 'package:lali/blocs/other_places_bloc.dart';
import 'package:lali/blocs/popular_places_bloc.dart';
import 'package:lali/blocs/recent_places_bloc.dart';
import 'package:lali/blocs/recommanded_places_bloc.dart';
import 'package:lali/blocs/search_bloc.dart';
import 'package:lali/blocs/sign_in_bloc.dart';
import 'package:lali/blocs/sp_state_one.dart';
import 'package:lali/blocs/sp_state_two.dart';
import 'package:lali/blocs/state_bloc.dart';
import 'package:lali/blocs/events_bloc.dart';
import 'package:lali/blocs/bookings_bloc.dart';
import 'package:lali/core/utils/initial_bindings.dart';
import 'package:lali/firebase_options.dart';
import 'package:lali/router/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:lali/core/theme/app_theme.dart';
import 'package:lali/core/services/consent_prefs.dart';
import 'package:lali/core/config/app_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:lali/widgets/other_places.dart';

Future<void> _initRemoteConfig() async {
  final rc = FirebaseRemoteConfig.instance;
  await rc.setDefaults(const {
    'feature_guides_enabled': true,
    'max_places_per_list': 10,
    'low_end_map_mode': false,
  });
  try {
    await rc.fetchAndActivate();
  } catch (_) {
    // ignore fetch errors, keep defaults
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firestore offline persistence (guarded for web compatibility)
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (_) {
    // On web or restricted environments, ignore persistence setting errors
  }
  // Crashlytics: forward Flutter and zone errors (not available on web)
  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  // Respect user consent toggles for Analytics/Crashlytics
  final allowAnalytics = await ConsentPrefs.getAnalytics();
  final allowCrash = await ConsentPrefs.getCrash();
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(allowAnalytics);
  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(allowCrash);
  }

  // Set environment metadata for Crashlytics and Analytics
  final info = await PackageInfo.fromPlatform();
  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCustomKey('env', AppConfig.env);
    await FirebaseCrashlytics.instance.setCustomKey('app_version', '${info.version}+${info.buildNumber}');
  }
  if (allowAnalytics) {
    await FirebaseAnalytics.instance.setUserProperty(name: 'env', value: AppConfig.env);
  }

  // Analytics basic event
  await FirebaseAnalytics.instance.logAppOpen();

  // Remote Config
  await _initRemoteConfig();
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en', 'IN'), // English (India) default
      Locale('hi'), // Hindi
      Locale('bn'), // Bengali
      Locale('ta'), // Tamil
      Locale('te'), // Telugu
      Locale('mr'), // Marathi
      Locale('kn'), // Kannada
      Locale('en'), // Fallback English
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('en', 'IN'),
    startLocale: const Locale('en', 'IN'),
    useOnlyLangCode: false,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BlogBloc>(
          create: (context) => BlogBloc(),
        ),
        ChangeNotifierProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        ChangeNotifierProvider<SignInBloc>(
          create: (context) => SignInBloc(),
        ),
        ChangeNotifierProvider<CommentsBloc>(
          create: (context) => CommentsBloc(),
        ),
        ChangeNotifierProvider<BookmarkBloc>(
          create: (context) => BookmarkBloc(),
        ),
        ChangeNotifierProvider<PopularPlacesBloc>(
          create: (context) => PopularPlacesBloc(),
        ),
        ChangeNotifierProvider<RecentPlacesBloc>(
          create: (context) => RecentPlacesBloc(),
        ),
        ChangeNotifierProvider<RecommandedPlacesBloc>(
          create: (context) => RecommandedPlacesBloc(),
        ),
        ChangeNotifierProvider<FeaturedBloc>(
          create: (context) => FeaturedBloc(),
        ),
        ChangeNotifierProvider<SearchBloc>(create: (context) => SearchBloc()),
        ChangeNotifierProvider<NotificationBloc>(
            create: (context) => NotificationBloc()),
        ChangeNotifierProvider<StateBloc>(create: (context) => StateBloc()),
        ChangeNotifierProvider<SpecialStateOneBloc>(
            create: (context) => SpecialStateOneBloc()),
        ChangeNotifierProvider<SpecialStateTwoBloc>(
            create: (context) => SpecialStateTwoBloc()),
        ChangeNotifierProvider<OtherPlacesBloc>(
            create: (context) => OtherPlacesBloc()),
        ChangeNotifierProvider<EventsBloc>(
            create: (context) => EventsBloc()),
        ChangeNotifierProvider<BookingsBloc>(
            create: (context) => BookingsBloc()),
      ],
      child: GetMaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: AppConfig.env == 'prod' ? 'Lali' : 'Lali (${AppConfig.env})',
        theme: AppTheme.themeLight(seed: Colors.teal),
        darkTheme: AppTheme.themeDark(seed: Colors.teal),
        initialRoute: AppRoutes.home,
        getPages: AppRoutes.pages,
        initialBinding: InitialBindings(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: _analytics),
          if (!kIsWeb) _CrashlyticsNavObserver(),
        ],
      ),
    );
  }
}

class _CrashlyticsNavObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = route.settings.name ?? route.runtimeType.toString();
    FirebaseCrashlytics.instance.setCustomKey('last_screen', name);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = previousRoute?.settings.name ?? previousRoute?.runtimeType.toString() ?? 'unknown';
    FirebaseCrashlytics.instance.setCustomKey('last_screen', name);
    super.didPop(route, previousRoute);
  }
}

// width: 360
// height: 687
