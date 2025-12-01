import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/administration_item.dart';

class AdministrationService {
  final CollectionReference administrationRef =
      FirebaseFirestore.instance.collection('administration');

  Future<List<AdministrationItem>> getAdministration() async {
    final snapshot = await administrationRef.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return AdministrationItem.fromMap(doc.id, data);
    }).toList();
  }

  Future<void> addAdministration(AdministrationItem item) async {
    await administrationRef.doc(item.id).set(item.toMap());
  }

  Future<void> updateAdministration(AdministrationItem item) async {
    await administrationRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteAdministration(String id) async {
    await administrationRef.doc(id).delete();
  }
}

