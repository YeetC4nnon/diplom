import 'package:rs_booking/auth.dart';
import 'package:rs_booking/main.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = false;

    return isLoggedIn ? rs_booking() : Authorization();
  }
}
