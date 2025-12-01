import 'package:flutter/material.dart';
import 'package:sotkonya/model/administration_item.dart';
import 'package:sotkonya/services/administration_service.dart';

class AdministrationProvider extends ChangeNotifier {
  final AdministrationService _service = AdministrationService();

  List<AdministrationItem> _items = [];
  List<AdministrationItem> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchAdministration() async {
    _loading = true;
    notifyListeners();

    try {
      _items = await _service.getAdministration();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addAdministration(AdministrationItem item) async {
    await _service.addAdministration(item);
    await fetchAdministration();
  }

  Future<void> updateAdministration(AdministrationItem item) async {
    await _service.updateAdministration(item);
    await fetchAdministration();
  }

  Future<void> deleteAdministration(String id) async {
    await _service.deleteAdministration(id);
    await fetchAdministration();
  }
}
