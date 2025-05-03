import 'package:flutter/material.dart';
import '../presenter/alarm_presenter.dart';
import '../model/alarm_model.dart';

abstract class AlarmView {
  void showAlarmSetSuccess();
  void showAlarmError(String message);
}

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> implements AlarmView {
  late AlarmPresenter _presenter;
  DateTime _selectedDateTime = DateTime.now().add(Duration(minutes: 1));

  @override
  void initState() {
    super.initState();
    _presenter = AlarmPresenter(this);
  }

  void _setAlarm() {
    final model = AlarmModel(id: 1, dateTime: _selectedDateTime);
    _presenter.setAlarm(model);
  }

  @override
  void showAlarmSetSuccess() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Alarm set successfully!')));
  }

  @override
  void showAlarmError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $message')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Alarm')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text('Pick Alarm Time')),
          SizedBox(height: 16),
          ElevatedButton(onPressed: _setAlarm, child: Text('Set Alarm')),
        ]),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final time = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(_selectedDateTime));
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
}
