import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/car.dart';

class BookingProvider extends ChangeNotifier {
  Booking? _booking;
  Booking? get latestBooking => _booking;

  void createBooking({
    required String userName,
    required Car car,
    required DateTime fromDate,
    required DateTime toDate,
    required String location,
  }) {
    final days = toDate.difference(fromDate).inDays + 1;
    _booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: userName,
      car: car,
      fromDate: fromDate,
      toDate: toDate,
      location: location,
      totalPrice: days * car.pricePerDay,
    );
    notifyListeners();
  }

  void clearBooking() {
    _booking = null;
    notifyListeners();
  }
}
