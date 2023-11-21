import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheNetworkImage {
  static get customCacheManager => CacheManager(
        Config(
          'customCacheKey',
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
        ),
      );
}
