import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// عدد الأزواج لكل مستوى: 6 و 8 و 12 كارت
const kLevelPairs = [3, 4, 6];
const kLevelNames = ['الأول', 'التاني', 'التالت'];

/// الوقت الثابت لكل مستوى (بالثواني)
const kLevelSeconds = [120, 180, 300];

String fmtTime(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

class GameSettings extends ChangeNotifier {
  int selected = 0; // المستوى اللي الأهل اختاروه للطفل

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    selected = (p.getInt('selected_level') ?? selected)
        .clamp(0, kLevelPairs.length - 1)
        .toInt();
    notifyListeners();
  }

  Future<void> select(int i) async {
    selected = i;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt('selected_level', i);
  }
}