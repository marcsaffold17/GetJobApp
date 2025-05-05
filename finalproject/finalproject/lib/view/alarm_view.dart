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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Alarm set successfully!')));
    _loadAlarms();
  }

  @override
  void showAlarmError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: $message')));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDarkMode
            ? const Color.fromARGB(255, 80, 80, 80)
            : const Color.fromARGB(255, 244, 243, 240);

    final cardColor =
        isDarkMode
            ? const Color.fromARGB(255, 60, 60, 60)
            : const Color.fromARGB(255, 230, 230, 226);

    final appBarColor = const Color.fromARGB(255, 0, 43, 75);

    final titleColor =
        isDarkMode ? Colors.white : const Color.fromARGB(255, 0, 43, 75);

    final subtitleColor =
        isDarkMode
            ? const Color.fromARGB(255, 151, 151, 151)
            : const Color.fromARGB(255, 17, 84, 116);

    final timeColor =
        isDarkMode
            ? Colors.lightBlueAccent
            : const Color.fromARGB(255, 34, 124, 157);

    final alarmsByDate = <DateTime, List<AlarmModel>>{};
    for (var alarm in _alarms) {
      final date = DateTime(
        alarm.dateTime.year,
        alarm.dateTime.month,
        alarm.dateTime.day,
      );
      alarmsByDate.putIfAbsent(date, () => []).add(alarm);
    }

    final sortedDates =
        alarmsByDate.keys.toList()..sort((b, a) => b.compareTo(a));

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: backgroundColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        elevation: 2,
        title: Text(
          'Alarms',
          style: TextStyle(
            fontFamily: 'inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: backgroundColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child:
                  _alarms.isEmpty
                      ? Center(
                        child: Text(
                          "No alarms set.",
                          style: TextStyle(
                            color: timeColor.withAlpha(180),
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
                            color: cardColor,
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
                              backgroundColor: cardColor,
                              title: Text(
                                DateFormat('EEEE, MMMM d, y').format(date),
                                style: TextStyle(
                                  fontFamily: 'inter',
                                  color: titleColor,
                                ),
                              ),
                              children: [
                                Divider(color: titleColor, thickness: 1),
                                ...dailyAlarms.map(
                                  (alarm) => ListTile(
                                    dense: true,
                                    title: Text(
                                      alarm.title ?? 'Alarm',
                                      style: TextStyle(
                                        fontFamily: 'JetB',
                                        fontSize: 12,
                                        color: subtitleColor,
                                      ),
                                    ),
                                    trailing: Text(
                                      DateFormat(
                                        'hh:mm a',
                                      ).format(alarm.dateTime),
                                      style: TextStyle(
                                        fontFamily: 'JetB',
                                        fontSize: 12,
                                        color: timeColor,
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color.fromARGB(255, 0, 43, 75),
              onPrimary: Colors.white,
              surface: Theme.of(context).dialogBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color.fromARGB(255, 0, 43, 75),
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        },
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
