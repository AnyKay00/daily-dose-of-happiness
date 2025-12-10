import 'dart:math';


class MultiUrlApiManager {
    final Map<String, String> _apiRoutes = {};

    void addRoute(String routeName, String url) {
      _apiRoutes[routeName] = url;
    }

    String? getRandomRoute() {
      if (_apiRoutes.isEmpty) {
        throw Exception('No routes added.');
      }

      final random = Random();
      final index = random.nextInt((_apiRoutes.length));
      return _apiRoutes[_apiRoutes.keys.elementAt(index)];
    }
}