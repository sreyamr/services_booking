import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';
import '../../../data/models/booking_model.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final CollectionReference<Map<String, dynamic>> _ref =
  FirebaseFirestore.instance.collection('bookings');
  AppointmentBloc() : super(AppointmentInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<UpdateAppointmentStatus>(_updateStatus);

  }

  Future<void> _onLoadAppointments(
      LoadAppointments event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final snapshot = await  FirebaseFirestore.instance.collection('bookings').get();

      final appointments = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();

      emit(AppointmentLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _updateStatus(
      UpdateAppointmentStatus event,
      Emitter<AppointmentState> emit,
      ) async {
    if (state is! AppointmentLoaded) return;

    final current = (state as AppointmentLoaded).appointments;

    try {
      await _ref.doc(event.bookingId).update({
        'status': event.status,
      });

      final updated = current.map((e) {
        if (e.id == event.bookingId) {
          return e.copyWith(status: event.status);
        }
        return e;
      }).toList();

      emit(AppointmentLoaded(updated));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}