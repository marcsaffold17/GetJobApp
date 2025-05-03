import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/calander_model.dart';

class MyCalanderPage extends StatefulWidget {
  const MyCalanderPage({super.key});

  @override
  _MyCalanderPage createState() => _MyCalanderPage();
}

class _MyCalanderPage extends State<MyCalanderPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode =
      RangeSelectionMode
          .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [for (final d in days) ..._getEventsForDay(d)];
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

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
    // _showAddEventDialog(selectedDay);
  }

  void _showAddEventDialog(DateTime day) {
    final TextEditingController _eventController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color.fromARGB(255, 244, 243, 240),
            title: const Text(
              "Add Event",
              style: TextStyle(
                fontFamily: 'inter',
                color: Color.fromARGB(255, 0, 43, 75),
              ),
            ),
            content: TextField(
              controller: _eventController,
              style: TextStyle(
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
            actions: [
              Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 202, 59, 59),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Color.fromARGB(255, 244, 243, 240)),
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 17, 84, 116),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextButton(
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;

                    setState(() {
                      final event = Event(_eventController.text);
                      if (kEvents[day] != null) {
                        kEvents[day]!.add(event);
                      } else {
                        kEvents[day] = [event];
                      }
                      _selectedEvents.value = _getEventsForDay(day);
                    });

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Color.fromARGB(255, 244, 243, 240)),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 244, 243, 240)),
      backgroundColor: Color.fromARGB(255, 244, 243, 240),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            width: 380,
            decoration: BoxDecoration(
              color: Color.fromARGB(40, 34, 124, 157),
              border: Border.all(
                color: Color.fromARGB(255, 0, 43, 75),
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 43, 75),
                  fontFamily: 'inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Color.fromARGB(255, 17, 84, 116),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Color.fromARGB(255, 17, 84, 116),
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
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
                  color: Color.fromARGB(255, 17, 84, 116),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 124, 157),
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
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 230, 230, 226),
                        color: Color.fromARGB(255, 17, 84, 116),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),

                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text(
                          '${value[index]}',
                          style: TextStyle(
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
            padding: EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: 250,
              height: 60,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 43, 75),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => _showAddEventDialog(_focusedDay),
                child: Text(
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
