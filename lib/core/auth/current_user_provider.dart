import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

final currentUserRoleProvider = FutureProvider<String>((ref) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: AppConstants.userRoleKey) ?? 'Sales';
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role == 'Admin';
});
