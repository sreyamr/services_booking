import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_booking/widgets/app_button.dart';
import 'package:service_booking/widgets/text_fields.dart';
import '../../core/theme/app_color.dart';
import '../../core/theme/app_text_style.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/category_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/show_confirm_dialog.dart';
import '../booking/bloc/booking_bloc.dart';
import '../booking/bloc/booking_event.dart';
import '../booking/bloc/booking_state.dart';

class ProviderDetailScreen extends StatelessWidget {
  final dynamic provider;
  final String? userName;

  const ProviderDetailScreen({super.key, required this.provider,required this.userName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingBloc(),
      child: _ProviderDetailBody(provider: provider, userName: userName,),
    );
  }
}

class _ProviderDetailBody extends StatefulWidget {
  final dynamic provider;
  final String? userName;
  const _ProviderDetailBody({required this.provider,required this.userName});

  @override
  State<_ProviderDetailBody> createState() => _ProviderDetailBodyState();
}

class _ProviderDetailBodyState extends State<_ProviderDetailBody> {
  bool _isDialogVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.provider.name,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingLoading && !_isDialogVisible) {
            _isDialogVisible = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                  child: CircularProgressIndicator(
                color: AppColors.primary,
              )),
            );
          } else if (state is BookingSuccess || state is BookingFailure) {
            if (_isDialogVisible) {
              Navigator.of(context, rootNavigator: true).pop();
              _isDialogVisible = false;
            }

            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking Confirmed!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                context.push(AppRoutes.home);

              });
            } else if (state is BookingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.network(
                      widget.provider.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name
              Center(
                child: Text(
                  widget.provider.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              // Description
              if (widget.provider.description != null &&
                  widget.provider.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.provider.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Rating & Price
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _InfoBadge(
                      text: "⭐ ${widget.provider.rating}",
                      color: Colors.yellow.shade100),
                  const SizedBox(width: 8),
                  _InfoBadge(
                      text: "₹${widget.provider.pricePerMinute}/min",
                      color: Colors.purple.shade100),
                ],
              ),
              const SizedBox(height: 20),

              // Experience & Availability
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue.shade100]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Experience: ${widget.provider.experience} years"),
                    const SizedBox(height: 8),
                    Text(
                      "Availability: ${widget.provider.isOnline ? "Online" : "Offline"}",
                      style: TextStyle(
                          color: widget.provider.isOnline
                              ? Colors.green
                              : Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Reviews
              const Text("Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              widget.provider.review == null
                  ? const Text("No reviews yet")
                  : Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.grey),
                        title: Text(widget.provider.review!.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(widget.provider.review!.comment),
                        trailing: Text("⭐ ${widget.provider.review!.rating}",
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
              const SizedBox(height: 30),

              // Book Appointment Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'Book Appointment',
                    onTap: _bookAppointment,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _bookAppointment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (selectedDate == null) return;

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime == null) return;

    DateTime bookingDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    bool? confirm = await showConfirmationDialog(
      context: context,
      title: "Confirm Booking",
      content:
      "Do you want to book with ${widget.provider.name} on "
          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year} "
          "at ${selectedTime.format(context)}?",
    );

    if (confirm != true) return;

    final booking = BookingModel(
      userId: user.uid,
      providerId: widget.provider.id,
      dateTime: bookingDateTime,
      slot: selectedTime.format(context),
      userName: widget.userName.toString(),
      providerName: widget.provider.name, id:user.uid
    );

    context.read<BookingBloc>().add(CreateBookingEvent(booking));
  }
}

class _InfoBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _InfoBadge({required this.text, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.poppinsBold(fontSize: 14),
      ),
    );
  }
}
