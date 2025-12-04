import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotkonya/model/yurt_model.dart';

class YurtService {
  final CollectionReference yurtRef =
      FirebaseFirestore.instance.collection('yurtlar');

  Future<List<YurtModel>> getYurtlar() async {
    final snapshot = await yurtRef.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return YurtModel.fromMap(doc.id, data);
    }).toList();
  }

  Future<void> addYurt(YurtModel item) async {
    await yurtRef.doc(item.id).set(item.toMap());
  }

  Future<void> updateYurt(YurtModel item) async {
    await yurtRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteYurt(String id) async {
    await yurtRef.doc(id).delete();
  }
}

