import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_finder/custom_widget/navigation_drawer.dart';
import 'package:parking_finder/pages/welcome_page.dart';
import 'package:parking_finder/providers/booking_provider.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/providers/map_provider.dart';
import 'package:parking_finder/providers/parking_provider.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/services/Auth_service.dart';
import 'package:parking_finder/utilities/appConst.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  ErrorWidget.builder = (details) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(child: Text("Some Thing Error Happened")),
          Center(
            child: OutlinedButton(
                onPressed: () {
                  Get.offAll(const CustomNavigationDrawer(),
                      transition: Transition.fadeIn);
                },
                child: const Text("Refresh")),
          )
        ],
      ),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log("FCMToken : $fcmToken");
  AuthService.fcmToken = fcmToken;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoginProvider()),
    ChangeNotifierProvider(create: (context) => MapProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => BookingProvider()),
    ChangeNotifierProvider(create: (context) => ParkingProvider()),
  ], child: const MyApp()));

  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.black12, // status bar color
    ));

    // AuthService.logout();
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: AnimatedSplashScreen(
        splash: appLogo,
        splashIconSize: double.infinity,
        backgroundColor: Colors.black,
        nextScreen: const WelcomePage(),
      ),
      builder: EasyLoading.init(),
    );
  }
}
