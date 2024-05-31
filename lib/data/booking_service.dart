class BookingService {
  final String serviceName;
  final DateTime bookingStart;
  final DateTime bookingEnd;
  final Duration serviceDuration;

  BookingService({
    required this.serviceName,
    required this.bookingStart,
    required this.bookingEnd,
    required this.serviceDuration,
  });
}
