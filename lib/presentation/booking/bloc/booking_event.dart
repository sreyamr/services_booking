import '../../../data/models/booking_model.dart';

abstract class BookingEvent {}

class CreateBookingEvent extends BookingEvent {
  final BookingModel booking;

  CreateBookingEvent(this.booking);
}
