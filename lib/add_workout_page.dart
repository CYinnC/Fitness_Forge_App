import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({super.key});

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  List<Map<String, dynamic>> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('workouts');
    setState(() {
      _workouts = existing != null
          ? List<Map<String, dynamic>>.from(json.decode(existing))
          : [];
    });
  }

  void _addField() {
    setState(() {
      _workouts.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': '',
        'reps': '10'
      });
    });
  }

  void _deleteWorkout(String id) {
    setState(() {
      _workouts.removeWhere((w) => w['id'] == id);
    });
  }

  void _saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('workouts', json.encode(_workouts));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Workout Plan'),
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (_workouts.isEmpty)
              const Center(
                child: Text(
                  "No workouts yet. Add some below.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ..._workouts.map((workout) {
              return Card(
                color: const Color(0xAA4B0082),
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: TextEditingController(text: workout['name']),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Workout Name',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                        ),
                        onChanged: (val) {
                          workout['name'] = val;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: workout['reps'],
                        dropdownColor: const Color(0xFF4B0082),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Reps',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        items: [
                          '5','10','15','20','25','30','35','40','45','50',
                          '55','60','65','70','75','80','85','90','95','100'
                        ]
                            .map((rep) => DropdownMenuItem(
                          value: rep,
                          child: Text('$rep Reps'),
                        ))
                            .toList(),
                        onChanged: (val) {
                          workout['reps'] = val;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _deleteWorkout(workout['id']),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addField,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B0082),
                foregroundColor: const Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveWorkouts,
              icon: const Icon(Icons.save),
              label: const Text('Save Workouts'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B0082),
                foregroundColor: const Color(0xFFFFD700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
