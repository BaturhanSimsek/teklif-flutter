import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_template_model.freezed.dart';
part 'form_template_model.g.dart';

@freezed
class FormTemplate with _$FormTemplate {
  const factory FormTemplate({
    required String             id,
    required String             name,
    String?                     description,
    required bool               isDefault,
    required List<TemplateField> fields,
  }) = _FormTemplate;

  factory FormTemplate.fromJson(Map<String, dynamic> json) =>
      _$FormTemplateFromJson(json);
}

@freezed
class TemplateField with _$TemplateField {
  const factory TemplateField({
    required String       id,
    required String       key,
    required String       label,
    required int          type, // 1=Text 2=Number 3=Decimal 4=Select 5=MultiSelect 6=Checkbox 7=Date 8=TextArea
    required bool         isRequired,
    required bool         showInPdf,
    required int          sortOrder,
    String?               defaultValue,
    required List<String> options,
  }) = _TemplateField;

  factory TemplateField.fromJson(Map<String, dynamic> json) =>
      _$TemplateFieldFromJson(json);
}
