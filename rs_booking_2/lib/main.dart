import 'package:flutter/material.dart';
import 'package:rs_booking_2/firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:rs_booking_2/pages/auth_page.dart';
import 'package:rs_booking_2/pages/home_page.dart';
import 'package:rs_booking_2/pages/user_page.dart';
import 'package:rs_booking_2/services/models.dart';

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
  //static final _appRouter = AppRouter();
  //final _observer = Observer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //routerConfig: _appRouter.config(navigatorObservers: () => [_observer],
      //initialRoutes: ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthorizationPage(),
        'HomePage': (context) => const HomePage(),
        'StudioAuthPage': (context) => const StudioAuthorizationPage(),
        'UserPage':(context) => UserPage(token: isUser.toString()),
      },
      title: 'RS-Booking',
      theme: ThemeData(
        textTheme: TextTheme(
          titleMedium: const TextStyle(
            fontSize: 16,
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
          color: Color.fromARGB(255, 44, 114, 245),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 128, 95, 95),
      ),
    );
  }
}
