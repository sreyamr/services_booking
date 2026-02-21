import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String docId;
  final int categoryId;
  final String name;
  final String image;

  CategoryModel({
    required this.docId,
    required this.categoryId,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromMap(String docId, Map<String, dynamic> map) {
    return CategoryModel(
      docId: docId,
      categoryId: (map['categoryId'] is int)
          ? map['categoryId']
          : int.tryParse(map['categoryId'].toString()) ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }
}


class ProviderModel {
  final String id;
  final String name;
  final int categoryId;
  final int experience;
  final double rating;
  final int pricePerMinute;
  final bool isOnline;
  final String image;
  final String description;
  final ReviewModel? review;

  ProviderModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.experience,
    required this.rating,
    required this.pricePerMinute,
    required this.isOnline,
    required this.image,
    required this.review,
    required this.description,
  });

  factory ProviderModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    ReviewModel? reviewModel;
    if (data['review'] != null) {
      reviewModel = ReviewModel.fromMap(
        Map<String, dynamic>.from(data['review']),
      );
    }

    return ProviderModel(
      id: doc.id,
      name: data['name'] ?? '',
      categoryId: data['categoryId'] ?? 0,
      experience: data['experience'] ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      pricePerMinute: data['pricePerMinute'] ?? 0,
      isOnline: data['isOnline'] ?? false,
      image: data['image'] ?? '',
      description: data['description'] ?? '',
      review: reviewModel, // convert Firestore map to Dart map
    );
  }
}
class ReviewModel {
  final String name;
  final double rating;
  final String comment;

  ReviewModel({
    required this.name,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      name: map['name'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
    );
  }
}