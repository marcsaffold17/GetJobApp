import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/calendar_model.dart';
import '../presenter/global_presenter.dart';
import '../presenter/alarm_presenter.dart';
import '../model/alarm_model.dart';
import '../view/alarm_view.dart';

class MyCalendarPage extends StatefulWidget {
  const MyCalendarPage({super.key});

  @override
  _MyCalendarPage createState() => _MyCalendarPage();
}

class _MyCalendarPage extends State<MyCalendarPage> implements AlarmView {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Map<DateTime, List<Event>> _events = {};
  late AlarmPresenter _alarmPresenter;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEventsForMonth(_focusedDay);
    _alarmPresenter = AlarmPresenter(this);
  }

  Future<List<Event>> _getEventsForDay(DateTime day) async {
    final dateKey = DateUtils.dateOnly(day).toIso8601String();
    final snapshot =
    await FirebaseFirestore.instance
        .collection('Login-Info')
        .doc(globalEmail)
        .collection('Calendar')
        .doc(dateKey)
        .collection('events')
        .get();

    return snapshot.docs.map((doc) {
      // Retrieve time data and combine it with event title
      int hour = doc['hour'] ?? 0;
      int minute = doc['minute'] ?? 0;
      String formattedTime = _formatTime(hour, minute);
      return Event("${doc['title']} ($formattedTime)");
    }).toList();
  }



  String _formatTime(int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
  }

  void _showAddEventDialog(DateTime day) {
    final TextEditingController _eventController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 244, 243, 240),
        title: const Text(
          "Add Event",
          style: TextStyle(
            fontFamily: 'inter',
            color: Color.fromARGB(255, 0, 43, 75),
          ),
        ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _eventController,
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
                    labelText: "Event Title",
                    labelStyle: TextStyle(
                      color: Color.fromARGB(150, 17, 84, 116),
                      fontFamily: 'JetB',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 17, 84, 116),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                  child: Text("Pick Time: ${selectedTime.format(context)}"),
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
              if (_eventController.text.isEmpty) return;

              final event = _eventController.text;
              final dateKey = DateUtils.dateOnly(day).toIso8601String();

              final alarmDateTime = DateTime(
                day.year,
                day.month,
                day.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              try {
                await FirebaseFirestore.instance
                    .collection('Login-Info')
                    .doc(globalEmail)
                    .collection('Calendar')
                    .doc(dateKey)
                    .collection('events')
                    .add({
                  'title': event,
                  'hour': selectedTime.hour,
                  'minute': selectedTime.minute,
                });

                await _loadEvents(DateTime.now());

                final alarmModel = AlarmModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  dateTime: alarmDateTime,
                  title: _eventController.text,
                );

                await _alarmPresenter.setAlarm(alarmModel);
                await _loadEvents(DateTime.now());

                setState(() {});
                Navigator.pop(context);
              } catch (e) {
                print("Error saving event: $e");
              }
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

  Future<void> _loadEvents(DateTime dateKey) async {
    final normalizedDate = DateTime(dateKey.year, dateKey.month, dateKey.day);
    final docId = normalizedDate.toIso8601String();

    try {
      final eventSnapshot =
      await FirebaseFirestore.instance
          .collection('Login-Info')
          .doc(globalEmail)
          .collection('Calendar')
          .doc(docId)
          .collection('events')
          .get();

      final events =
      eventSnapshot.docs
          .map((doc) => Event(doc['title'] as String))
          .toList();

      // Replace the old list instead of appending
      _events[normalizedDate] = events;

      setState(() {});
    } catch (e) {
      print('Error loading events for $docId: $e');
    }
  }

  void _loadEventsForMonth(DateTime focusedDay) {
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    for (int i = 0; i < lastDay.day; i++) {
      final day = firstDay.add(Duration(days: i));
      _loadEvents(day);
    }
  }

  @override
  void showAlarmSetSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alarm set successfully!")),
    );
  }

  @override
  void showAlarmError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Alarm error: $message")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 243, 240),
        title: const Text(
          "Calendar",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 43, 75),
            fontFamily: 'inter',
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 43, 75)),
      ),
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 380,
            decoration: BoxDecoration(
              color: const Color.fromARGB(40, 34, 124, 157),
              border: Border.all(
                color: const Color.fromARGB(255, 0, 43, 75),
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TableCalendar<Event>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: (day) => _events[DateUtils.dateOnly(day)] ?? [],
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
                if (true) {
                  print(_events);
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                _loadEventsForMonth(focusedDay);
              },
              headerStyle: const HeaderStyle(
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 43, 75),
                  fontFamily: 'inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Color.fromARGB(255, 0, 43, 75),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Color.fromARGB(255, 0, 43, 75),
                ),
                formatButtonDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 43, 75),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Color.fromARGB(255, 244, 243, 240),
                  fontFamily: 'JetB',
                ),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: Color.fromARGB(255, 17, 84, 116),
                  fontFamily: 'inter',
                ),
                weekdayStyle: TextStyle(
                  color: Color.fromARGB(255, 17, 84, 116),
                  fontFamily: 'inter',
                ),
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 124, 157),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 17, 84, 116),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(
                  color: Color.fromARGB(255, 17, 84, 116),
                  fontFamily: 'JetB',
                ),
                defaultTextStyle: TextStyle(
                  color: Color.fromARGB(255, 17, 84, 116),
                  fontFamily: 'JetB',
                ),
                outsideTextStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future:
              _selectedDay != null
                  ? _getEventsForDay(_selectedDay!)
                  : Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No events."));
                }

                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 17, 84, 116),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 43, 75),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          '${events[index]}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 244, 243, 240),
                            fontFamily: 'JetB',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: 250,
              height: 60,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 43, 75),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed:
                    () => _showAddEventDialog(_selectedDay ?? _focusedDay),
                child: const Text(
                  "Add Interview",
                  style: TextStyle(
                    color: Color.fromARGB(255, 244, 243, 240),
                    fontFamily: 'JetB',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
