// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FormTemplate _$FormTemplateFromJson(Map<String, dynamic> json) {
  return _FormTemplate.fromJson(json);
}

/// @nodoc
mixin _$FormTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  List<TemplateField> get fields => throw _privateConstructorUsedError;

  /// Serializes this FormTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FormTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FormTemplateCopyWith<FormTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormTemplateCopyWith<$Res> {
  factory $FormTemplateCopyWith(
          FormTemplate value, $Res Function(FormTemplate) then) =
      _$FormTemplateCopyWithImpl<$Res, FormTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      bool isDefault,
      List<TemplateField> fields});
}

/// @nodoc
class _$FormTemplateCopyWithImpl<$Res, $Val extends FormTemplate>
    implements $FormTemplateCopyWith<$Res> {
  _$FormTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FormTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? isDefault = null,
    Object? fields = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      fields: null == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<TemplateField>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormTemplateImplCopyWith<$Res>
    implements $FormTemplateCopyWith<$Res> {
  factory _$$FormTemplateImplCopyWith(
          _$FormTemplateImpl value, $Res Function(_$FormTemplateImpl) then) =
      __$$FormTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      bool isDefault,
      List<TemplateField> fields});
}

/// @nodoc
class __$$FormTemplateImplCopyWithImpl<$Res>
    extends _$FormTemplateCopyWithImpl<$Res, _$FormTemplateImpl>
    implements _$$FormTemplateImplCopyWith<$Res> {
  __$$FormTemplateImplCopyWithImpl(
      _$FormTemplateImpl _value, $Res Function(_$FormTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FormTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? isDefault = null,
    Object? fields = null,
  }) {
    return _then(_$FormTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      fields: null == fields
          ? _value._fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<TemplateField>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormTemplateImpl implements _FormTemplate {
  const _$FormTemplateImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.isDefault,
      required final List<TemplateField> fields})
      : _fields = fields;

  factory _$FormTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final bool isDefault;
  final List<TemplateField> _fields;
  @override
  List<TemplateField> get fields {
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fields);
  }

  @override
  String toString() {
    return 'FormTemplate(id: $id, name: $name, description: $description, isDefault: $isDefault, fields: $fields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            const DeepCollectionEquality().equals(other._fields, _fields));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, isDefault,
      const DeepCollectionEquality().hash(_fields));

  /// Create a copy of FormTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormTemplateImplCopyWith<_$FormTemplateImpl> get copyWith =>
      __$$FormTemplateImplCopyWithImpl<_$FormTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormTemplateImplToJson(
      this,
    );
  }
}

abstract class _FormTemplate implements FormTemplate {
  const factory _FormTemplate(
      {required final String id,
      required final String name,
      final String? description,
      required final bool isDefault,
      required final List<TemplateField> fields}) = _$FormTemplateImpl;

  factory _FormTemplate.fromJson(Map<String, dynamic> json) =
      _$FormTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  bool get isDefault;
  @override
  List<TemplateField> get fields;

  /// Create a copy of FormTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormTemplateImplCopyWith<_$FormTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateField _$TemplateFieldFromJson(Map<String, dynamic> json) {
  return _TemplateField.fromJson(json);
}

/// @nodoc
mixin _$TemplateField {
  String get id => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  int get type =>
      throw _privateConstructorUsedError; // 1=Text 2=Number 3=Decimal 4=Select 5=MultiSelect 6=Checkbox 7=Date 8=TextArea
  bool get isRequired => throw _privateConstructorUsedError;
  bool get showInPdf => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  String? get defaultValue => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;

  /// Serializes this TemplateField to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateFieldCopyWith<TemplateField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateFieldCopyWith<$Res> {
  factory $TemplateFieldCopyWith(
          TemplateField value, $Res Function(TemplateField) then) =
      _$TemplateFieldCopyWithImpl<$Res, TemplateField>;
  @useResult
  $Res call(
      {String id,
      String key,
      String label,
      int type,
      bool isRequired,
      bool showInPdf,
      int sortOrder,
      String? defaultValue,
      List<String> options});
}

/// @nodoc
class _$TemplateFieldCopyWithImpl<$Res, $Val extends TemplateField>
    implements $TemplateFieldCopyWith<$Res> {
  _$TemplateFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? label = null,
    Object? type = null,
    Object? isRequired = null,
    Object? showInPdf = null,
    Object? sortOrder = null,
    Object? defaultValue = freezed,
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      showInPdf: null == showInPdf
          ? _value.showInPdf
          : showInPdf // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateFieldImplCopyWith<$Res>
    implements $TemplateFieldCopyWith<$Res> {
  factory _$$TemplateFieldImplCopyWith(
          _$TemplateFieldImpl value, $Res Function(_$TemplateFieldImpl) then) =
      __$$TemplateFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String key,
      String label,
      int type,
      bool isRequired,
      bool showInPdf,
      int sortOrder,
      String? defaultValue,
      List<String> options});
}

/// @nodoc
class __$$TemplateFieldImplCopyWithImpl<$Res>
    extends _$TemplateFieldCopyWithImpl<$Res, _$TemplateFieldImpl>
    implements _$$TemplateFieldImplCopyWith<$Res> {
  __$$TemplateFieldImplCopyWithImpl(
      _$TemplateFieldImpl _value, $Res Function(_$TemplateFieldImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? label = null,
    Object? type = null,
    Object? isRequired = null,
    Object? showInPdf = null,
    Object? sortOrder = null,
    Object? defaultValue = freezed,
    Object? options = null,
  }) {
    return _then(_$TemplateFieldImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      showInPdf: null == showInPdf
          ? _value.showInPdf
          : showInPdf // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateFieldImpl implements _TemplateField {
  const _$TemplateFieldImpl(
      {required this.id,
      required this.key,
      required this.label,
      required this.type,
      required this.isRequired,
      required this.showInPdf,
      required this.sortOrder,
      this.defaultValue,
      required final List<String> options})
      : _options = options;

  factory _$TemplateFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateFieldImplFromJson(json);

  @override
  final String id;
  @override
  final String key;
  @override
  final String label;
  @override
  final int type;
// 1=Text 2=Number 3=Decimal 4=Select 5=MultiSelect 6=Checkbox 7=Date 8=TextArea
  @override
  final bool isRequired;
  @override
  final bool showInPdf;
  @override
  final int sortOrder;
  @override
  final String? defaultValue;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'TemplateField(id: $id, key: $key, label: $label, type: $type, isRequired: $isRequired, showInPdf: $showInPdf, sortOrder: $sortOrder, defaultValue: $defaultValue, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateFieldImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.showInPdf, showInPdf) ||
                other.showInPdf == showInPdf) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      key,
      label,
      type,
      isRequired,
      showInPdf,
      sortOrder,
      defaultValue,
      const DeepCollectionEquality().hash(_options));

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateFieldImplCopyWith<_$TemplateFieldImpl> get copyWith =>
      __$$TemplateFieldImplCopyWithImpl<_$TemplateFieldImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateFieldImplToJson(
      this,
    );
  }
}

abstract class _TemplateField implements TemplateField {
  const factory _TemplateField(
      {required final String id,
      required final String key,
      required final String label,
      required final int type,
      required final bool isRequired,
      required final bool showInPdf,
      required final int sortOrder,
      final String? defaultValue,
      required final List<String> options}) = _$TemplateFieldImpl;

  factory _TemplateField.fromJson(Map<String, dynamic> json) =
      _$TemplateFieldImpl.fromJson;

  @override
  String get id;
  @override
  String get key;
  @override
  String get label;
  @override
  int get type; // 1=Text 2=Number 3=Decimal 4=Select 5=MultiSelect 6=Checkbox 7=Date 8=TextArea
  @override
  bool get isRequired;
  @override
  bool get showInPdf;
  @override
  int get sortOrder;
  @override
  String? get defaultValue;
  @override
  List<String> get options;

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateFieldImplCopyWith<_$TemplateFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
