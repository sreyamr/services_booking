import 'package:cloud_firestore/cloud_firestore.dart';



class BookingModel {
  final String id;
  final String userId;
  final String userName;
  final String providerId;
  final String providerName;
  final DateTime dateTime;
  final String slot;
  final String status;

  BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.providerId,
    required this.providerName,
    required this.dateTime,
    required this.slot,
    this.status = 'pending',
  });

  BookingModel copyWith({String? status}) {
    return BookingModel(
      id: id,
      userId: userId,
      userName: userName,
      providerId: providerId,
      providerName: providerName,
      dateTime: dateTime,
      slot: slot,
      status: status ?? this.status,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      id: id,
      'userId': userId,
      'userName': userName,
      'providerId': providerId,
      'providerName': providerName,
      'dateTime': dateTime.toIso8601String(),
      'slot': slot,
      'status': status,
    };
  }


  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final rawDate = data['dateTime'];

    DateTime parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else {
      parsedDate = DateTime.parse(rawDate);
    }

    return BookingModel(
      id: doc.id,
      userId: data['userId'],
      userName: data['userName'],
      providerId: data['providerId'],
      providerName: data['providerName'],
      dateTime: parsedDate,
      slot: data['slot'],
      status: data['status'],
    );
  }
}
