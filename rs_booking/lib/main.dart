import 'package:flutter/material.dart';
import 'package:rs_booking/start.dart';

void main() => runApp(rs_booking());

class rs_booking extends StatelessWidget {
  const rs_booking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS-booking',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(50, 65, 85, 1),
      ),
      home: StartPage(),
    );
  }
}
