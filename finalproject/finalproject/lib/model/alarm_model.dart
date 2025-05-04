import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel {
  final DateTime dateTime;
  final String id;
  final String? title;

  AlarmModel({required this.id, required this.dateTime, this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'title': title,
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      title: map['title'],
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

