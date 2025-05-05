import 'package:flutter/material.dart';
import '../model/goal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/goals_presenter.dart';
import '../presenter/global_presenter.dart';
import '../view/navBar_view.dart';
import 'package:intl/intl.dart';

class ChecklistPage extends StatefulWidget {
  final bool isFromNavbar;

  const ChecklistPage({Key? key, required this.isFromNavbar}) : super(key: key);

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  List<ChecklistItem> items = [];
  final _textController = TextEditingController();
  final ChecklistPresenter presenter = ChecklistPresenter();

  final favoritesRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalEmail)
      .collection('checklist');

  @override
  void initState() {
    super.initState();
    presenter.loadItems().then((loadedItems) {
      setState(() {
        items = loadedItems;
      });
    });
  }

  void _save() => presenter.saveItems(items);

  void _addItem(String text) {
    setState(() {
      items.add(ChecklistItem(text: text, isChecked: false, date: null));
    });
    _textController.clear();
    _save();
  }

  void _toggleItem(int index) {
    setState(() {
      items[index].isChecked = !items[index].isChecked;
    });
    _save();
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    _save();
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context, int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        items[index].date = picked;
        _selectedDate = picked;
      });
      _save();
    }
  }

  IconData _selectedIcon = Icons.work;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 244, 238, 227),
        ),
        centerTitle: true,
        title: const Text(
          'Career Goals',
          style: TextStyle(
            color: Color.fromARGB(255, 244, 238, 227),
            fontFamily: 'inter',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      drawer: widget.isFromNavbar ? NavigationMenuView() : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(40, 34, 124, 157),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          // filled: true,
                          // fillColor: Color.fromARGB(40, 34, 124, 157),
                          hintText: 'Add a career goal...',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(140, 17, 84, 116),
                            fontFamily: 'JetB',
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (text) {
                          if (text.isNotEmpty) _addItem(text);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_rounded,
                        color: Color.fromARGB(255, 34, 124, 157),
                      ),
                      onPressed: () {
                        if (_textController.text.isNotEmpty) {
                          _addItem(_textController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  items.isEmpty
                      ? Center(
                        child: Text(
                          'No goals yet. Add one!',
                          style: TextStyle(
                            color: Color.fromARGB(130, 34, 124, 157),
                            fontFamily: 'JetB',
                            fontSize: 18,
                          ),
                        ),
                      )
                      : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Dismissible(
                            key: Key(item.text + index.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _removeItem(index),
                            background: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: const Color.fromARGB(238, 202, 59, 59),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 230, 230, 226),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _selectedIcon,
                                        color: Color.fromARGB(255, 0, 43, 75),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item.text,
                                          style: TextStyle(
                                            fontFamily: 'JetB',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            decoration:
                                                item.isChecked
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                            color:
                                                item.isChecked
                                                    ? Colors.grey
                                                    : Color.fromARGB(
                                                      255,
                                                      17,
                                                      84,
                                                      116,
                                                    ),
                                          ),
                                        ),
                                      ),
                                      Checkbox(
                                        activeColor: const Color.fromARGB(
                                          255,
                                          0,
                                          43,
                                          75,
                                        ),
                                        value: item.isChecked,
                                        onChanged: (_) => _toggleItem(index),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.date != null
                                            ? 'Due: ${DateFormat.yMMMd().format(item.date!)}'
                                            : 'No due date',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily:
                                              'JetB', // or 'MontserratB' or any other you've added
                                          color: Color.fromARGB(255, 0, 43, 75),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => _selectDate(context, index),
                                        child: const Text(
                                          'Set Date',
                                          style: TextStyle(
                                            fontFamily:
                                                'JetB', // use your preferred font
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                              255,
                                              34,
                                              124,
                                              157,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
}
