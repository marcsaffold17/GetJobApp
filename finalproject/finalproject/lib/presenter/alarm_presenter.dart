import 'package:alarm/alarm.dart';
import '../model/alarm_model.dart';
import '../view/alarm_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlarmPresenter {
  final AlarmView view;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AlarmPresenter(this.view);

  Future<void> setAlarm(AlarmModel alarmModel) async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        view.showAlarmError("User not logged in");
        return;
      }

      final alarmSettings = AlarmSettings(
        id: alarmModel.id.hashCode,
        dateTime: alarmModel.dateTime,
        assetAudioPath: 'assets/iphone_radar.mp3',
        loopAudio: true,
        vibrate: true,
        fadeDuration: 3.0,
        notificationTitle: 'Alarm',
        notificationBody: alarmModel.title ?? 'Interview Time!!',
        enableNotificationOnKill: true,
      );

      await Alarm.set(alarmSettings: alarmSettings);

      await _firestore
          .collection('Login-Info')
          .doc(userEmail)
          .collection('alarms')
          .doc(alarmModel.id)
          .set(alarmModel.toMap());

      view.showAlarmSetSuccess();
    } catch (e) {
      view.showAlarmError(e.toString());
    }
  }

  Future<List<AlarmModel>> fetchAlarms() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        view.showAlarmError("User not logged in");
        return [];
      }

      final snapshot = await _firestore
          .collection('Login-Info')
          .doc(userEmail)
          .collection('alarms')
          .get();

      return snapshot.docs
          .map((doc) => AlarmModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      view.showAlarmError(e.toString());
      return [];
    }
  }
}

