import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppointments extends AppointmentEvent {}
class UpdateAppointmentStatus extends AppointmentEvent {
  final String bookingId;
  final String status;

  UpdateAppointmentStatus({
    required this.bookingId,
    required this.status,
  });
}