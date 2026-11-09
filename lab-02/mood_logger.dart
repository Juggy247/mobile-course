import 'dart:io';

class MoodEntry {
  DateTime createdAt;
  int score;
  String? note;

  MoodEntry(this.createdAt, this.score, this.note);

  @override
  String toString() {
    
    String time = createdAt.toString().substring(0, 16);
    return '[$time] Score: $score/10 - ${note ?? '(no note)'}';
  }
}

class MoodLogger {
  List<MoodEntry> entries = [];

  void addEntry(int score, String? note) {
    if (score < 1 || score > 10) {
      print('Error: score must be between 1 and 10.');
      return;
    }
    if (note != null && note.trim().isEmpty) {
      note = null;
    }
    entries.add(MoodEntry(DateTime.now(), score, note));
    print('Entry added.');
  }

  List<MoodEntry> getAllEntries() => entries;

  double? getAverageScore() {
    if (entries.isEmpty) return null;
    int total = 0;
    for (var e in entries) {
      total += e.score;
    }
    return total / entries.length;
  }

  List<MoodEntry> getEntriesAbove(int threshold) =>
      entries.where((e) => e.score >= threshold).toList();
}

void main() {
  var logger = MoodLogger();
 
  while (true) {
    
    print('');
    print('=== Mood Logger ===');
    print('1. Add entry');
    print('2. View all entries');
    print('3. View average');
    print('4. Filter by score');
    print('5. Quit');
    stdout.write('Choose: ');
 
    String? choice = stdin.readLineSync();
 
    if (choice == '1') {
      stdout.write('Score (1-10): ');
      int? score = int.tryParse(stdin.readLineSync() ?? '');
 
      if (score == null) {
        print('Please enter a number.');
        continue;
      }
 
      stdout.write('Note (optional): ');
      String? note = stdin.readLineSync();
 
      logger.addEntry(score, note);
    }
 
    else if (choice == '2') {
      var all = logger.getAllEntries();
 
      if (all.isEmpty) {
        print('No entries yet. Add some entries first!');
      }
 
      for (var e in all) {
        print(e);
      }
    }
 
    else if (choice == '3') {
      double? avg = logger.getAverageScore();
 
      if (avg == null) {
        print('No entries yet. Add some entries first!');
      } else {
        int count = logger.entries.length;
        print('Average mood score: ${avg.toStringAsFixed(1)} '
            '(based on $count entries)');
      }
    }
 
    else if (choice == '4') {
      stdout.write('Minimum score: ');
      int? min = int.tryParse(stdin.readLineSync() ?? '');
 
      if (min == null) {
        print('Please enter a number.');
        continue;
      }
 
      for (var e in logger.getEntriesAbove(min)) {
        print(e);
      }
    }
 
    else if (choice == '5' || choice == null) {
      print('Goodbye!');
      break;
    }
 
    else {
      print('Invalid option.');
    }
  }
}