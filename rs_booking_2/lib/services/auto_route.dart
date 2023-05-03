import 'package:auto_route/auto_route.dart';

import 'auto_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AdaptiveRoute(page: AuthorizationRoute.page, path: '/'),
        AdaptiveRoute(page: HomeRoute.page, path: 'HomePage'),
        AdaptiveRoute(page: RecordRoute.page, path: 'RecordPage')
      ];
}
