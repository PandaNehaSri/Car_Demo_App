class Car {
  final String id;
  final String name;
  final String imageUrl;
  final double pricePerDay;
  final String seats;
  final String transmission;
  final bool available;
  final double rating;
  final String category;

  Car({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.pricePerDay,
    required this.seats,
    required this.transmission,
    required this.available,
    required this.rating,
    required this.category,
  });
}

final mockCars = <Car>[
  Car(
    id: 'c1',
    name: 'Hyundai Creta',
    imageUrl: 'assets/suv_car_1.png',
    pricePerDay: 2500,
    seats: '5',
    transmission: 'Automatic',
    available: true,
    rating: 4.8,
    category: 'SUV',
  ),
  Car(
    id: 'c2',
    name: 'Maruti Swift',
    imageUrl: 'assets/swift_car_1.png',
    pricePerDay: 1800,
    seats: '5',
    transmission: 'Manual',
    available: true,
    rating: 4.5,
    category: 'Hatchback',
  ),
  Car(
    id: 'c3',
    name: 'Toyota Innova',
    imageUrl: 'assets/innova_car_1.png',
    pricePerDay: 4200,
    seats: '7',
    transmission: 'Automatic',
    available: false,
    rating: 4.9,
    category: 'MPV',
  ),
];
