import 'package:flutter/material.dart';
import 'package:rs_booking_2/firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:rs_booking_2/pages/auth_page.dart';
import 'package:rs_booking_2/pages/home_page.dart';
import 'package:rs_booking_2/pages/record_page.dart';

import 'services/auto_route.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const rs_booking_2());
}

// ignore: camel_case_types
class rs_booking_2 extends StatelessWidget {
  const rs_booking_2({super.key});
  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //routerConfig: _appRouter.config(),
      routes: {
        '/':(context) => const AuthorizationPage(),
        'HomePage':(context) => const HomePage(),
      },
      initialRoute: '/',
      title: 'RS-Booking',
      theme: ThemeData(
        textTheme: TextTheme(
          titleMedium: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
          titleLarge: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.white24,
        ),
        cardTheme: const CardTheme(
          elevation: 1,
          color: Colors.amber,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 128, 95, 95),
      ),
    );
  }
}
