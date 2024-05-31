import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:intl/intl.dart';
import 'package:takwira_app/views/messages/chat2.dart';

class FieldBooking extends StatefulWidget {
  final dynamic field;
  const FieldBooking({super.key, this.field});

  @override
  _FieldBookingState createState() => _FieldBookingState();
}

class _FieldBookingState extends State<FieldBooking> {
  final now = DateTime.now();
  late BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
    mockBookingService = BookingService(
      serviceName: widget.field['name'] ?? 'Field Service',
      serviceDuration: 30,
      bookingStart: DateTime(now.year, now.month, now.day, 0, 0),
      bookingEnd: DateTime(now.year, now.month, now.day, 23, 59),
    );
  }

  Stream<dynamic>? getBookingStream(
      {required DateTime start, required DateTime end}) {
    return Stream.value(widget.field['reservations']);
  }

  Future<dynamic> uploadBooking({required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    // Upload the booking data
    print('${newBooking.toJson()} has been uploaded');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Chat2()),
    );
  }

  List<DateTimeRange> convertStreamResult({required dynamic streamResult}) {
  List<dynamic> reservations = streamResult ?? [];
  List<DateTimeRange> bookedSlots = [];

  for (var reservation in reservations) {
    DateTime startDate = DateTime.parse(reservation['startDate']);

    startDate = startDate.subtract(Duration(hours: 1));

    DateTime endDate = DateTime.parse(reservation['endDate']);

    endDate = endDate.subtract(Duration(minutes: 30));

    bookedSlots.add(DateTimeRange(start: startDate, end: endDate));
  }

  return bookedSlots;
}


  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 8, 0).toLocal(),
        end: DateTime(now.year, now.month, now.day, 12, 0).toLocal(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Field Booking',
      home: Scaffold(
        backgroundColor: const Color(0xff474D48),
        body: Center(
          child: BookingCalendar(
            bookingButtonColor: Color(0xFF7EA087),
            bookedSlotColor: Color(0xffBD4747),
            bookedSlotTextStyle: TextStyle(color: Color(0xffF1EED0)),
            selectedSlotColor: Color(0xffCC901C),
            availableSlotColor: Color(0xff599068),
            availableSlotTextStyle: TextStyle(color: Color(0xffF1EED0)),
            pauseSlotColor: Color(0xffA09F8D),
            bookingService: mockBookingService,
            convertStreamResultToDateTimeRanges: convertStreamResult,
            getBookingStream: getBookingStream,
            uploadBooking: uploadBooking,
            pauseSlots: generatePauseSlots(),
            pauseSlotText: 'Closed',
            hideBreakTime: false,
            loadingWidget: const Text('Fetching data...'),
            uploadingWidget: const CircularProgressIndicator(
              color: Color(0xff599068),
            ),
            locale: 'en_TN',
            startingDayOfWeek: StartingDayOfWeek.monday,
            wholeDayIsBookedWidget:
                const Text('Sorry, for this day everything is booked'),
          ),
        ),
      ),
    );
  }
}
