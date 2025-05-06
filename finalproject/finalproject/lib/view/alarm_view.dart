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
  DateTime _selectedDateTime = DateTime.now();

  List<AlarmModel> _alarms = [];

  final TextEditingController _alarmTitleController = TextEditingController();
  TimeOfDay _selectedAlarmTime = TimeOfDay.now();

  DateTime _selectedAlarmDate = DateTime.now();


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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Alarm set successfully!')));
    _loadAlarms();
  }

  @override
  void showAlarmError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: $message')));
  }

  void _showAddAlarmDialog() {
    final DateTime today = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 244, 243, 240),
        title: const Text(
          "Add Alarm",
          style: TextStyle(
            fontFamily: 'inter',
            color: Color.fromARGB(255, 0, 43, 75),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _alarmTitleController,
              style: const TextStyle(
                color: Color.fromARGB(255, 34, 124, 157),
                fontFamily: 'JetB',
              ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 17, 84, 116),
                    width: 2.0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 34, 124, 157),
                    width: 2.0,
                  ),
                ),
                labelText: "Alarm Title",
                labelStyle: TextStyle(
                  color: Color.fromARGB(150, 17, 84, 116),
                  fontFamily: 'JetB',
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedAlarmDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        textTheme: ThemeData.light().textTheme.apply(
                          fontFamily: 'inter',
                        ),
                        colorScheme: ColorScheme.light(
                          primary: Color.fromARGB(255, 0, 43, 75),
                          onPrimary: Color.fromARGB(255, 230, 230, 226), // selected text
                          onSurface: Color.fromARGB(255, 17, 84, 116), // default text
                        ),
                        dialogBackgroundColor: Color.fromARGB(255, 244, 243, 240),
                        datePickerTheme: DatePickerThemeData(
                          headerBackgroundColor: Color.fromARGB(255, 0, 43, 75),
                          headerForegroundColor: Color.fromARGB(255, 230, 230, 226),
                          backgroundColor: Color.fromARGB(255, 244, 243, 240),
                          dayStyle: TextStyle(
                            fontFamily: 'inter',
                            color: Color.fromARGB(255, 17, 84, 116),
                          ),
                          weekdayStyle: TextStyle(
                            fontFamily: 'inter',
                            color: Color.fromARGB(150, 17, 84, 116),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedAlarmDate = pickedDate;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 17, 84, 116),
                foregroundColor: Colors.white,
              ),
              child: Text(
                "Pick Date: ${_selectedAlarmDate.month}/${_selectedAlarmDate.day}/${_selectedAlarmDate.year}",
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 17, 84, 116),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedAlarmTime,
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        textTheme: ThemeData.light().textTheme.apply(
                          fontFamily:
                          'inter',
                        ),
                        colorScheme: ColorScheme.light(
                          primary: Color.fromARGB(255, 0, 43, 75),
                          onPrimary: const Color.fromARGB(
                            255,
                            230,
                            230,
                            226,
                          ),
                          onSurface: const Color.fromARGB(
                            255,
                            17,
                            84,
                            116,
                          ),
                        ),
                        timePickerTheme: TimePickerThemeData(
                          helpTextStyle: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 43, 75),
                            fontFamily: 'inter',
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            244,
                            243,
                            240,
                          ),
                          dayPeriodColor: WidgetStateColor.resolveWith((
                              states,
                              ) {
                            return states.contains(WidgetState.selected)
                                ? Color.fromARGB(255, 0, 43, 75)
                                : Colors.white;
                          }),
                          dayPeriodTextColor: WidgetStateColor.resolveWith((
                              states,
                              ) {
                            return states.contains(WidgetState.selected)
                                ? Color.fromARGB(255, 230, 230, 226)
                                : Color.fromARGB(255, 17, 84, 116);
                          }),
                        ),
                      ),

                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _selectedAlarmTime = picked;
                  });
                }
              },
              child: Text("Pick Time: ${_selectedAlarmTime.format(context)}"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 202, 59, 59),
              foregroundColor: Colors.white,
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (_alarmTitleController.text.isEmpty) return;

              final now = DateTime.now();
              final selectedDateTime = DateTime(
                _selectedAlarmDate.year,
                _selectedAlarmDate.month,
                _selectedAlarmDate.day,
                _selectedAlarmTime.hour,
                _selectedAlarmTime.minute,
              );

              final alarmModel = AlarmModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                dateTime: selectedDateTime.isBefore(now)
                    ? selectedDateTime.add(Duration(days: 1))
                    : selectedDateTime,
                title: _alarmTitleController.text,
              );

              await _presenter.setAlarm(alarmModel);
              _alarmTitleController.clear();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 17, 84, 116),
              foregroundColor: Colors.white,
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Alarms are grouped by date
    final alarmsByDate = <DateTime, List<AlarmModel>>{};
    for (var alarm in _alarms) {
      final date = DateTime(
        alarm.dateTime.year,
        alarm.dateTime.month,
        alarm.dateTime.day,
      );
      alarmsByDate.putIfAbsent(date, () => []).add(alarm);
    }

    // Dates sorted by most to least recent
    final sortedDates =
        alarmsByDate.keys.toList()..sort((b, a) => b.compareTo(a));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 244, 243, 240),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        elevation: 2,
        title: const Text(
          'Alarms',
          style: TextStyle(
            fontFamily: 'inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 244, 243, 240),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAddAlarmDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 43, 75),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Add Alarm',
                style: TextStyle(fontSize: 20, fontFamily: 'JetB'),
              ),
            ),

            Expanded(
              child:
                  _alarms.isEmpty
                      ? Center(
                        child: Text(
                          "No alarms set.",
                          style: TextStyle(
                            color: Color.fromARGB(130, 34, 124, 157),
                            fontFamily: 'JetB',
                            fontSize: 18,
                          ),
                        ),
                      )
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
                              backgroundColor: const Color.fromARGB(
                                255,
                                230,
                                230,
                                226,
                              ),
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
                                ...dailyAlarms.map(
                                  (alarm) => ListTile(
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
                                      DateFormat(
                                        'hh:mm a',
                                      ).format(alarm.dateTime),
                                      style: const TextStyle(
                                        fontFamily: 'JetB',
                                        fontSize: 12,
                                        color: Color.fromARGB(
                                          255,
                                          34,
                                          124,
                                          157,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
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
