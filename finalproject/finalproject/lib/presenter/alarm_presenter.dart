import 'package:alarm/alarm.dart';
import '../model/alarm_model.dart';
import '../view/alarm_view.dart';

class AlarmPresenter {
  final AlarmView view;

  AlarmPresenter(this.view);

  Future<void> setAlarm(AlarmModel alarmModel) async {
    try {
      final alarmSettings = AlarmSettings(
        id: alarmModel.id,
        dateTime: alarmModel.dateTime,
        assetAudioPath: 'assets/iphone_radar.mp3',
        loopAudio: true,
        vibrate: true,
        fadeDuration: 3.0,
        notificationTitle: 'Alarm',
        notificationBody: 'Time to wake up!',
        enableNotificationOnKill: true,
      );
      await Alarm.set(alarmSettings: alarmSettings);

      view.showAlarmSetSuccess();
    } catch (e) {
      view.showAlarmError(e.toString());
    }
  }
}
