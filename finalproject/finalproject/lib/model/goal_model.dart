class ChecklistItem {
  String text;
  bool isChecked;
  DateTime? date; // <-- Add this line

  ChecklistItem({
    required this.text,
    required this.isChecked,
    this.date, // <-- Add this
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isChecked': isChecked,
      'date': date?.toIso8601String(), // <-- Add this
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      text: map['text'] ?? '',
      isChecked: map['isChecked'] ?? false,
      date:
          map['date'] != null
              ? DateTime.parse(map['date'])
              : null, // <-- Add this
    );
  }
}
