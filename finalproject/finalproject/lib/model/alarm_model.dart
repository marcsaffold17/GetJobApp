import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel {
  final DateTime dateTime;
  final String id;

  AlarmModel({required this.id, required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  factory AlarmModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return AlarmModel(
      id: map['id'] ?? int.parse(doc.id),
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}

