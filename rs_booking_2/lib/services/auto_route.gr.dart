// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:rs_booking_2/pages/auth_page.dart' as _i1;
import 'package:rs_booking_2/pages/home_page.dart' as _i2;
import 'package:rs_booking_2/pages/record_page.dart' as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    AuthorizationRoute.name: (routeData) {
      return _i4.AutoRoutePage<void>(
        routeData: routeData,
        child: const _i1.AuthorizationPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i4.AutoRoutePage<void>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    RecordRoute.name: (routeData) {
      final args = routeData.argsAs<RecordRouteArgs>(
          orElse: () => const RecordRouteArgs());
      return _i4.AutoRoutePage<void>(
        routeData: routeData,
        child: _i3.RecordPage(
          key: args.key,
          data: args.data,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthorizationPage]
class AuthorizationRoute extends _i4.PageRouteInfo<void> {
  const AuthorizationRoute({List<_i4.PageRouteInfo>? children})
      : super(
          AuthorizationRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthorizationRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.RecordPage]
class RecordRoute extends _i4.PageRouteInfo<RecordRouteArgs> {
  RecordRoute({
    _i5.Key? key,
    Map<String, dynamic>? data,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          RecordRoute.name,
          args: RecordRouteArgs(
            key: key,
            data: data,
          ),
          initialChildren: children,
        );

  static const String name = 'RecordRoute';

  static const _i4.PageInfo<RecordRouteArgs> page =
      _i4.PageInfo<RecordRouteArgs>(name);
}

class RecordRouteArgs {
  const RecordRouteArgs({
    this.key,
    this.data,
  });

  final _i5.Key? key;

  final Map<String, dynamic>? data;

  @override
  String toString() {
    return 'RecordRouteArgs{key: $key, data: $data}';
  }
}
