import 'package:flutter/material.dart';
import 'package:sotkonya/model/yurt_model.dart';
import 'package:sotkonya/services/yurt_service.dart';

class YurtProvider extends ChangeNotifier {
  final YurtService _service = YurtService();

  List<YurtModel> _items = [];
  List<YurtModel> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchYurtlar() async {
    _loading = true;
    notifyListeners();

    try {
      _items = await _service.getYurtlar();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addYurt(YurtModel item) async {
    await _service.addYurt(item);
    await fetchYurtlar();
  }

  Future<void> updateYurt(YurtModel item) async {
    await _service.updateYurt(item);
    await fetchYurtlar();
  }

  Future<void> deleteYurt(String id) async {
    await _service.deleteYurt(id);
    await fetchYurtlar();
  }
}
