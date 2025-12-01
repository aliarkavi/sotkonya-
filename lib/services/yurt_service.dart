import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/yurt_item.dart';

class YurtService {
  final CollectionReference yurtRef =
      FirebaseFirestore.instance.collection('yurtlar');

  Future<List<YurtItem>> getYurtlar() async {
    final snapshot = await yurtRef.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return YurtItem.fromMap(doc.id, data);
    }).toList();
  }

  Future<void> addYurt(YurtItem item) async {
    await yurtRef.doc(item.id).set(item.toMap());
  }

  Future<void> updateYurt(YurtItem item) async {
    await yurtRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteYurt(String id) async {
    await yurtRef.doc(id).delete();
  }
}

