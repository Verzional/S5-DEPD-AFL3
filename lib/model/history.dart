part of 'model.dart';

class History extends Equatable {
  final String type;
  final String origin;
  final String destination;
  final int weight;
  final String courier;
  final DateTime timestamp;

  const History({
    required this.type,
    required this.origin,
    required this.destination,
    required this.weight,
    required this.courier,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [type, origin, destination, weight, courier, timestamp];
}
