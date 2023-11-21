// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_ssru_map/backend/screens/dashboard_screen.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:provider/provider.dart';

// providers
import 'package:flutter_ssru_map/providers/content_provider.dart';
import 'package:flutter_ssru_map/providers/locations_provider.dart';
import 'package:flutter_ssru_map/providers/user_provider.dart';
import 'package:flutter_ssru_map/providers/gender_provider.dart';

// router
import 'package:flutter_ssru_map/routes.dart';

// screens
import 'package:flutter_ssru_map/frontend/screens/splashToHome_screen.dart';
import 'package:flutter_ssru_map/frontend/screens/splashToLoginRegis_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => LocationsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GenderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

final navigatorState = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SSRU Map Application',
      theme: ThemeData(
        fontFamily: K2D,
        textTheme: const TextTheme(
          button: TextStyle(fontFamily: K2D),
        ),
      ),
      routes: AppRoute.all,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return const SplashToHomeScreen();
          } else {
            return const SplashToLoginRegisScreen();
          }
        },
      ),
      // home: DashboardScreen(),
      navigatorKey: navigatorState,
    );
  }
}
