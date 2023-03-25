import 'package:flutter/material.dart';
import 'package:rs_booking/auth.dart';
import 'package:rs_booking/home.dart';
import 'package:rs_booking/record.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/auth':
        return MaterialPageRoute(builder: (_) => const Authorization());
      case '/recordPage':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => RecordPage(
              data: args,
            ),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
