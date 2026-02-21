abstract class BookingState {}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingSuccess extends BookingState {}
class BookingFailure extends BookingState {
  final String message;
  BookingFailure(this.message);
}