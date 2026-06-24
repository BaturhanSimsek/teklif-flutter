import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
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
    final res = await _dio.get('/formtemplates');
    final list = res.data as List<dynamic>;
    return list.map((e) => FormTemplate.fromJson(e as Map<String, dynamic>)).toList();
  }
}
