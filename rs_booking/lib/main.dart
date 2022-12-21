import 'package:flutter/material.dart';
import 'package:rs_booking/firebase_options.dart';
import 'package:rs_booking/home.dart';
import 'package:firebase_core/firebase_core.dart';

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
      home: const HomePage(),
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(50, 65, 85, 1),
      ),
    );
  }
}
