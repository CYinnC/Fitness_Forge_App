import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietJournalPage extends StatefulWidget {
  const DietJournalPage({super.key});

  @override
  State<DietJournalPage> createState() => _DietJournalPageState();
}

class _DietJournalPageState extends State<DietJournalPage> {
  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  String _selectedDay = 'Monday';

  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    _breakfastController.text = prefs.getString('$_selectedDay-breakfast') ?? '';
    _lunchController.text = prefs.getString('$_selectedDay-lunch') ?? '';
    _dinnerController.text = prefs.getString('$_selectedDay-dinner') ?? '';
  }

  Future<void> _saveMeals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_selectedDay-breakfast', _breakfastController.text);
    await prefs.setString('$_selectedDay-lunch', _lunchController.text);
    await prefs.setString('$_selectedDay-dinner', _dinnerController.text);
  }

  void _onDayChanged(String? newDay) async {
    if (newDay == null) return;
    await _saveMeals();
    setState(() {
      _selectedDay = newDay;
    });
    _loadMeals();
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            onChanged: (_) => _saveMeals(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _breakfastController.dispose();
    _lunchController.dispose();
    _dinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Journal'),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
          child: ListView(
            children: [
              const Text(
                'Plan your meals:',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDay,
                dropdownColor: const Color(0xFF6A0DAD),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF6A0DAD),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: _days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: _onDayChanged,
              ),
              const SizedBox(height: 16),
              _buildTextField("Breakfast", _breakfastController),
              _buildTextField("Lunch", _lunchController),
              _buildTextField("Dinner", _dinnerController),
            ],
          ),
        ),
      ),
    );
  }
}
