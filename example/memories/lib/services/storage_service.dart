import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/memory.dart';

class StorageService {
  static const String _memoriesKey = 'memories';

  Future<void> saveMemories(List<Memory> memories) async {
    final prefs = await SharedPreferences.getInstance();
    final memoriesJson = memories
        .map((memory) => json.encode(memory.toJson()))
        .toList();
    await prefs.setStringList(_memoriesKey, memoriesJson);
  }

  Future<List<Memory>> loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final memoriesJson = prefs.getStringList(_memoriesKey) ?? [];
    return memoriesJson
        .map((jsonStr) => Memory.fromJson(json.decode(jsonStr)))
        .toList();
  }

  Future<void> clearMemories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_memoriesKey);
  }
}
