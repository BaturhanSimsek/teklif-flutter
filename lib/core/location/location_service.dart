import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../api/api_client.dart';
import '../constants/api_paths.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  final dio = ref.watch(dioProvider);
  return LocationService(dio);
});

class LocationService {
  LocationService(this._dio);

  final Dio _dio;
  Timer? _timer;

  /// Uygulama açılışında çağır — izin iste ve periyodik gönderimi başlat
  Future<void> initialize() async {
    final permission = await _requestPermission();
    if (!permission) return;
    await _send();
    _timer = Timer.periodic(const Duration(minutes: 10), (_) => _send());
  }

  void dispose() {
    _timer?.cancel();
  }

  Future<bool> _requestPermission() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return perm == LocationPermission.whileInUse || perm == LocationPermission.always;
  }

  Future<void> _send() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      await _dio.patch(ApiPaths.userLocation, data: {'lat': pos.latitude, 'lng': pos.longitude});
    } catch (_) {
      // Konum alınamazsa veya API hatası varsa sessizce geç
    }
  }
}
