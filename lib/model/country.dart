part of 'model.dart';

class Country extends Equatable {
  final String? code;
  final String? name;

  const Country({this.code, this.name});

  factory Country.fromJson(Map<String, dynamic> json) =>
      Country(code: json['code'] as String?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'code': code, 'name': name};

  @override
  List<Object?> get props => [code, name];
}