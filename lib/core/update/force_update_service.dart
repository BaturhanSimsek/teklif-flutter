import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateService {
  ForceUpdateService(this._dio);

  final Dio _dio;

  Future<UpdateCheckResult> check() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final res  = await _dio.get('/app-version');
      final data = res.data as Map<String, dynamic>;

      final current = _parse(info.version);
      final minimum = _parse(data['minimumVersion'] as String? ?? '0.0.0');
      final latest  = _parse(data['latestVersion']  as String? ?? '0.0.0');

      final needsForce    = _compare(current, minimum) < 0;
      final updateAvail   = _compare(current, latest)  < 0;

      return UpdateCheckResult(
        currentVersion  : info.version,
        minimumVersion  : data['minimumVersion'] as String? ?? '0.0.0',
        latestVersion   : data['latestVersion']  as String? ?? '0.0.0',
        updateUrl       : data['updateUrl']       as String? ?? '',
        forceUpdate     : needsForce,
        updateAvailable : updateAvail,
        message         : data['message']         as String? ?? '',
      );
    } catch (_) {
      return const UpdateCheckResult(
        currentVersion  : '',
        minimumVersion  : '',
        latestVersion   : '',
        updateUrl       : '',
        forceUpdate     : false,
        updateAvailable : false,
        message         : '',
      );
    }
  }

  List<int> _parse(String v) {
    final parts = v.split('.').map(int.tryParse);
    return [
      parts.elementAtOrNull(0) ?? 0,
      parts.elementAtOrNull(1) ?? 0,
      parts.elementAtOrNull(2) ?? 0,
    ];
  }

  int _compare(List<int> a, List<int> b) {
    for (var i = 0; i < 3; i++) {
      if (a[i] != b[i]) return a[i].compareTo(b[i]);
    }
    return 0;
  }
}

class UpdateCheckResult {
  const UpdateCheckResult({
    required this.currentVersion,
    required this.minimumVersion,
    required this.latestVersion,
    required this.updateUrl,
    required this.forceUpdate,
    required this.updateAvailable,
    required this.message,
  });

  final String  currentVersion;
  final String  minimumVersion;
  final String  latestVersion;
  final String  updateUrl;
  final bool    forceUpdate;
  final bool    updateAvailable;
  final String  message;
}
