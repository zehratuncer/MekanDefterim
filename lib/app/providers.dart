import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/app_database.dart';
import '../features/places/data/datasources/place_local_data_source.dart';
import '../features/places/data/repositories/place_repository_impl.dart';
import '../features/places/domain/repositories/place_repository.dart';

/// Veritabanı singleton sağlayıcısı
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Yerel veri kaynağı sağlayıcısı
final placeLocalDataSourceProvider = Provider<PlaceLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PlaceLocalDataSource(db);
});

/// Place Repository sağlayıcısı
final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  final dataSource = ref.watch(placeLocalDataSourceProvider);
  return PlaceRepositoryImpl(dataSource);
});
