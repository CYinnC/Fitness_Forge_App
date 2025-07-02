import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_workout_page.dart';

class DailyFitnessQuestPage extends StatefulWidget {
  const DailyFitnessQuestPage({super.key});

  @override
  State<DailyFitnessQuestPage> createState() => _DailyFitnessQuestPageState();
}

class _DailyFitnessQuestPageState extends State<DailyFitnessQuestPage> {
  List<Map<String, dynamic>> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('workouts');
    final timestamps = prefs.getString('completedTimestamps');
    final now = DateTime.now();

    if (data != null) {
      List<Map<String, dynamic>> loaded =
      List<Map<String, dynamic>>.from(json.decode(data));
      Map<String, dynamic> completedMap = timestamps != null
          ? Map<String, dynamic>.from(json.decode(timestamps))
          : {};

      _workouts = loaded.where((w) {
        final completedTime = completedMap[w['id']] != null
            ? DateTime.parse(completedMap[w['id']])
            : null;
        return completedTime == null ||
            now.difference(completedTime).inHours >= 24;
      }).toList();
    }

    setState(() {});
  }

  Future<void> _completeWorkout(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamps = prefs.getString('completedTimestamps');
    Map<String, dynamic> completedMap = timestamps != null
        ? Map<String, dynamic>.from(json.decode(timestamps))
        : {};

    completedMap[id] = DateTime.now().toIso8601String();
    await prefs.setString('completedTimestamps', json.encode(completedMap));

    setState(() {
      _workouts.removeWhere((w) => w['id'] == id);
    });

  }

  void _goToAddWorkout() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
    );
    _loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Fitness Quest'),
        backgroundColor: const Color(0xFF4B0082),
        foregroundColor: const Color(0xFFFFD700),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _workouts.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'No workout quests yet.\nWait 24 hours for quests to reappear.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ListView.builder(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _workouts.length,
            itemBuilder: (context, index) {
              final workout = _workouts[index];
              return Card(
                color: const Color(0xAA4B0082),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    '${workout['name']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Reps: ${workout['reps']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A0DAD),
                      foregroundColor: const Color(0xFFFFD700),
                    ),
                    onPressed: () => _completeWorkout(workout['id']),
                    child: const Text('Complete'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddWorkout,
        backgroundColor: const Color(0xFF4B0082),
        child: const Icon(Icons.add, color: Color(0xFFFFD700)),
      ),
    );
  }
}
