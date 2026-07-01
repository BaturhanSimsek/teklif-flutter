import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/api_paths.dart';
import 'form_template_model.dart';

part 'form_template_repository.g.dart';

@riverpod
FormTemplateRepository formTemplateRepository(FormTemplateRepositoryRef ref) =>
    FormTemplateRepository(ref.watch(dioProvider));

@riverpod
Future<List<FormTemplate>> formTemplates(FormTemplatesRef ref) =>
    ref.watch(formTemplateRepositoryProvider).getAll();

class FormTemplateRepository {
  FormTemplateRepository(this._dio);
  final Dio _dio;

  Future<List<FormTemplate>> getAll() async {
    try {
      final res = await _dio.get(ApiPaths.formTemplates);
      final list = res.data as List<dynamic>;
      return list.map((e) => FormTemplate.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<String> create({
    required String name,
    String? description,
    bool isDefault = false,
    required List<Map<String, dynamic>> fields,
  }) async {
    try {
      final res = await _dio.post(ApiPaths.formTemplates, data: {
        'name':        name,
        'description': description,
        'isDefault':   isDefault,
        'fields':      fields,
      });
      return res.data['id'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete(ApiPaths.formTemplate(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
