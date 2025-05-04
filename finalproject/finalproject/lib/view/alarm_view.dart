import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  List<AlarmModel> _alarms = [];

  @override
  void initState() {
    super.initState();
    _presenter = AlarmPresenter(this);
    _loadAlarms();
  }

  void _loadAlarms() async {
    final alarms = await _presenter.fetchAlarms();
    setState(() {
      _alarms = alarms;
    });
  }

  @override
  void showAlarmSetSuccess() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Alarm set successfully!')));
    _loadAlarms();
  }

  @override
  void showAlarmError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $message')));
  }

  @override
  Widget build(BuildContext context) {

    // Alarms are grouped by date
    final alarmsByDate = <DateTime, List<AlarmModel>>{};
    for (var alarm in _alarms) {
      final date = DateTime(alarm.dateTime.year, alarm.dateTime.month, alarm.dateTime.day);
      alarmsByDate.putIfAbsent(date, () => []).add(alarm);
    }

    // Dates sorted by most to least recent
    final sortedDates = alarmsByDate.keys.toList()
      ..sort((b, a) => b.compareTo(a));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 230, 226),
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Alarms',
          style: TextStyle(
            fontFamily: 'inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 0, 43, 75),
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 43, 75)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Temporarily removing "pick alarm time" and "set alarm" buttons
            /*
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text('Pick Alarm Time'),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _setAlarm, child: Text('Set Alarm')),
            SizedBox(height: 16),
            */

            Expanded(
              child: _alarms.isEmpty
                  ? Center(child: Text("No alarms set."))
                  : ListView.builder(
                itemCount: sortedDates.length,
                padding: const EdgeInsets.all(12.0),
                itemBuilder: (context, index) {
                  final date = sortedDates[index];
                  final dailyAlarms = alarmsByDate[date]!;

                  return Card(
                    color: const Color.fromARGB(255, 230, 230, 226),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide.none,
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide.none,
                      ),
                      backgroundColor: const Color.fromARGB(255, 230, 230, 226),
                      title: Text(
                        DateFormat('EEEE, MMMM d, y').format(date),
                        style: const TextStyle(
                          fontFamily: 'inter',
                          color: Color.fromARGB(255, 0, 43, 75),
                        ),
                      ),
                      children: [
                        const Divider(
                          color: Color.fromARGB(255, 0, 43, 75),
                          thickness: 1,
                        ),
                        ...dailyAlarms.map((alarm) => ListTile(
                          dense: true,
                          title: Text(
                            alarm.title ?? 'Alarm',
                            style: const TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: Color.fromARGB(255, 17, 84, 116),
                            ),
                          ),
                          trailing: Text(
                            DateFormat('hh:mm a').format(alarm.dateTime),
                            style: const TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: Color.fromARGB(255, 34, 124, 157),
                            ),
                          ),
                        )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
