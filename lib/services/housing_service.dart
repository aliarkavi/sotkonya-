import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/housing_model.dart';

class HousingService {
  final CollectionReference houses = FirebaseFirestore.instance.collection('housing');

  Stream<List<Housing>> streamHousing() {
    return houses.orderBy('name').snapshots().map((snap) => snap.docs.map((d) => Housing.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<Housing?> getHousing(String id) async {
    final doc = await houses.doc(id).get();
    if (doc.exists) return Housing.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    return null;
  }

  Future<void> createHousing(Housing h) async {
    await houses.add(h.toMap());
  }

  Future<void> updateHousing(Housing h) async {
    await houses.doc(h.id).update(h.toMap());
  }

  Future<void> deleteHousing(String id) async {
    await houses.doc(id).delete();
  }
}
