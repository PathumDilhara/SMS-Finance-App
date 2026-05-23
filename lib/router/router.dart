import 'package:go_router/go_router.dart';
import 'package:sms_finance_app/router/router_paths.dart';

import '../screens/home_screen.dart';

class RouterClass {
  final router = GoRouter(
      initialLocation: "/${RouterPaths.home}",
      routes: [
        GoRoute(
            name: RouterPaths.home,
            path: "/${RouterPaths.home}",
        builder: (context, state) => HomeScreen(),)
      ]);
}
