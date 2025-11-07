import 'car.dart';

class Booking {
  final String id;
  final String userName;
  final Car car;
  final DateTime fromDate;
  final DateTime toDate;
  final String location;
  final double totalPrice;

  Booking({
    required this.id,
    required this.userName,
    required this.car,
    required this.fromDate,
    required this.toDate,
    required this.location,
    required this.totalPrice,
  });
}
