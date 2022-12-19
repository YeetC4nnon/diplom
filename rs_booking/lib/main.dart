import 'package:flutter/material.dart';
import 'package:rs_booking/home.dart';
import 'package:provider/provider.dart';
import 'package:rs_booking/services/list_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
