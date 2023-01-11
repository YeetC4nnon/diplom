import 'package:flutter/material.dart';
import 'package:rs_booking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rs_booking/routes/route_generator.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const rs_booking());
}

class rs_booking extends StatelessWidget {
  const rs_booking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS-booking',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(50, 65, 85, 1),
      ),
    );
  }
}
