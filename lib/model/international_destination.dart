part of 'model.dart';

class InternationalDestination extends Equatable {
  final int? id;
  final String? name;

  const InternationalDestination({this.id, this.name});

  factory InternationalDestination.fromJson(Map<String, dynamic> json) {
    // Handle id being String or Int in JSON
    var idVal = json['id'] ?? json['country_id'];
    int? idInt;
    if (idVal is String) {
      idInt = int.tryParse(idVal);
    } else if (idVal is int) {
      idInt = idVal;
    }

    return InternationalDestination(
      id: idInt,
      name: (json['name'] ?? json['country_name']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}
