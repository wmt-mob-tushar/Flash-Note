import 'package:firebase_core/firebase_core.dart';
import 'package:flash_note/redux/app_state.dart';
import 'package:flash_note/redux/app_store.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/screens/auth/home/home.dart';
import 'package:flash_note/screens/auth/notes/notes.dart';
import 'package:flash_note/screens/auth/notes_details/notes_details.dart';
import 'package:flash_note/screens/auth/profile/profile.dart';
import 'package:flash_note/screens/non_auth/login/login.dart';
import 'package:flash_note/screens/non_auth/onboarding/onboarding.dart';
import 'package:flash_note/screens/non_auth/sign_up/sign_up.dart';
import 'package:flash_note/screens/splash/splash.dart';
import 'package:flash_note/utils/constants.dart';
import 'package:flash_note/utils/navigation_service.dart';
import 'package:flash_note/utils/routes.dart';
import 'package:flash_note/utils/shared_pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:redux/redux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // for IOS update Info.plist file
  // <key>LSApplicationQueriesSchemes</key>
  // <array>
  // <string>undecimus</string>
  // <string>sileo</string>
  // <string>zbra</string>
  // <string>filza</string>
  // <string>activator</string>
  // <string>cydia</string>
  // </array>
  //
  // for more information visit https://pub.dev/packages/jailbreak_root_detection
  // if (await SecurityUtils().isDeviceCompromised()) {
  //   exit(0);
  // }

  //
  //  turn this on when you want security on dev mode as well
  // if(await SecurityUtils().isDevModeOn()){
  //   exit(0);
  // }
  //

  await SharedPrefUtils.init();
  await Firebase.initializeApp();
  final store = await AppStore.init();
  runApp(MyApp(store: store));
}

class MyApp extends StatefulWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  /// Initialize the base notification handler
  /// Reminder: Don't forget to add the app icon for notifications
  /// and update the basic info before proceeding with further project setup.
  // final NotificationHandler notificationHandler = NotificationHandler();

  /// Initialize the ConnectionChecker instance. This utility is used to monitor the device's internet connection status.
  /// Note:
  /// 1. Ensure to add the internet permission in the AndroidManifest.xml file for Android.
  /// 2. For iOS, add the internet permission in the Info.plist file.
  // final ConnectionChecker connectionChecker = ConnectionChecker();

  /// Initialize the TrackActiveDevices instance. This utility is used to track the active devices in the app.
  /// Note: Ensure to add the Firebase Realtime Database dependency in the pubspec.yaml file.
  /// dependencies:
  ///  firebase_database: ^latest_version
  ///  device_info_plus: ^latest_version
  ///  firebase_core: ^latest_version
  // final TrackActiveDevices trackActiveDevices = TrackActiveDevices();

  @override
  void initState() {
    super.initState();
  }

  Widget mainBuilder(_, __) {
    return OverlaySupport(
      child: StoreProvider<AppState>(
        store: widget.store,
        child: StoreConnector<AppState, String?>(
          builder: (context, String? selectedLocale) {
            return MaterialApp(
              navigatorKey: NavigationService.instance.navigationKey,
              initialRoute: Routes.splash,
              onGenerateRoute: (settings) => routeCalled(settings),
              locale: Locale(selectedLocale ?? "en"),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                ...GlobalMaterialLocalizations.delegates,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale("it")],

              /// Add Other language Locale her to use in app
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: FontFamily.primary,
                primarySwatch: ResColors.primarySwatch,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: ResColors.black,
                  surface: ResColors.white,
                ),
              ),
            );
          },
          converter: (state) => state.state.selectedLocale,
        ),
      ),
    );
  }

  static Route<dynamic>? routeCalled(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (context) => const Splash(),
        );
      case Routes.onBoardingRoute:
        return CustomPageRoute(
          child: const Onboarding(),
          slideDirection: SlideDirection.right,
        );
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case Routes.signUpRoute:
        return MaterialPageRoute(
          builder: (context) => const SignUp(),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (context) => const Home(),
        );
      case Routes.notesRoute:
        return MaterialPageRoute(
          builder:(context) => Notes(
            foldersId: settings.arguments! as String,
          ),
        );
      case Routes.noteDetailsRoute:
        return CustomPageRoute(
          child: NotesDetails(),
        );
      case Routes.profileRoute:
        return MaterialPageRoute(
          builder: (context) => const Profile(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Route not found!'),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: mainBuilder,
      designSize: const Size(375, 812),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
