import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/goal_model.dart';
import 'global_presenter.dart';

class ChecklistPresenter {
  final _checklistRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalEmail)
      .collection('checklist');

  Future<List<ChecklistItem>> loadItems() async {
    final snapshot = await _checklistRef.get();
    return snapshot.docs
        .map((doc) => ChecklistItem.fromMap(doc.data()))
        .toList();
  }

  Future<void> saveItems(List<ChecklistItem> items) async {
    final batch = FirebaseFirestore.instance.batch();

    final snapshot = await _checklistRef.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    for (var item in items) {
      batch.set(_checklistRef.doc(), item.toMap());
    }

    await batch.commit();
  }
}
