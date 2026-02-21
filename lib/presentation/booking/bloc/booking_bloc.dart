import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  BookingBloc() : super(BookingInitial()) {
    on<CreateBookingEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        await firestore.collection('bookings').add(event.booking.toMap());

        emit(BookingSuccess());
      } catch (e) {
        emit(BookingFailure(e.toString()));
      }
    });
  }
}