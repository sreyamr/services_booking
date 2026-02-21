import 'package:equatable/equatable.dart';
import '../../../data/models/booking_model.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<BookingModel> appointments;

  const AppointmentLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
