import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class NoDiskCacheManager {
  static const key = 'noDiskCacheManager';
  static CacheManager instance = CacheManager(
    Config(key, stalePeriod: const Duration(days: 1), maxNrOfCacheObjects: 0),
  );
}
