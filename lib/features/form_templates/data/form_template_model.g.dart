// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FormTemplateImpl _$$FormTemplateImplFromJson(Map<String, dynamic> json) =>
    _$FormTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isDefault: json['isDefault'] as bool,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => TemplateField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FormTemplateImplToJson(_$FormTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'isDefault': instance.isDefault,
      'fields': instance.fields,
    };

_$TemplateFieldImpl _$$TemplateFieldImplFromJson(Map<String, dynamic> json) =>
    _$TemplateFieldImpl(
      id: json['id'] as String,
      key: json['key'] as String,
      label: json['label'] as String,
      type: (json['type'] as num).toInt(),
      isRequired: json['isRequired'] as bool,
      showInPdf: json['showInPdf'] as bool,
      sortOrder: (json['sortOrder'] as num).toInt(),
      defaultValue: json['defaultValue'] as String?,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$TemplateFieldImplToJson(_$TemplateFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'label': instance.label,
      'type': instance.type,
      'isRequired': instance.isRequired,
      'showInPdf': instance.showInPdf,
      'sortOrder': instance.sortOrder,
      'defaultValue': instance.defaultValue,
      'options': instance.options,
    };
