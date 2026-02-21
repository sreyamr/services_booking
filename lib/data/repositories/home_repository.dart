import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class HomeRepository {
  final _db = FirebaseFirestore.instance;

  Stream<List<CategoryModel>> categories() {
    return _db.collection('categories').snapshots().map((snap) {
      return snap.docs.map((d) => CategoryModel.fromMap(d.id, d.data())).toList();
    });
  }

  Future<List<ProviderModel>> providersByCategoryPaged(
      int categoryId,
      int page, {
        int limit = 3,
      }) async {
    Query query = _db
        .collection('providers')
        .where('categoryId', isEqualTo: categoryId)
        .limit(limit);


    DocumentSnapshot? lastDoc;


    if (page > 1) {
      final prevSnap = await _db
          .collection('providers')
          .where('categoryId', isEqualTo: categoryId)
          .limit((page - 1) * limit)
          .get();

      if (prevSnap.docs.isNotEmpty) {
        lastDoc = prevSnap.docs.last;
        query = query.startAfterDocument(lastDoc);
      }
    }

    final snap = await query.get();

    return snap.docs.map((d) => ProviderModel.fromDoc(d)).toList();
  }
}