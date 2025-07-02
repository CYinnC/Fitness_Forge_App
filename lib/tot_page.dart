import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TotPage extends StatefulWidget {
  const TotPage({super.key});

  @override
  State<TotPage> createState() => _TotPageState();
}

class _TotPageState extends State<TotPage> {
  bool _walkEnabled = false;
  bool _waterEnabled = false;
  bool _restEnabled = false;

  Timer? _walkTimer;
  Timer? _waterTimer;
  Timer? _restTimer;

  @override
  void initState() {
    super.initState();
    _loadToggleStates();
  }

  Future<void> _loadToggleStates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _walkEnabled = prefs.getBool('walkEnabled') ?? false;
      _waterEnabled = prefs.getBool('waterEnabled') ?? false;
      _restEnabled = prefs.getBool('restEnabled') ?? false;
    });
    _startOrStopTimers();
  }

  Future<void> _saveToggleStates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkEnabled', _walkEnabled);
    await prefs.setBool('waterEnabled', _waterEnabled);
    await prefs.setBool('restEnabled', _restEnabled);
  }

  @override
  void dispose() {
    _walkTimer?.cancel();
    _waterTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void _startOrStopTimers() {
    _walkTimer?.cancel();
    _waterTimer?.cancel();
    _restTimer?.cancel();

    if (_walkEnabled) {
      _walkTimer = Timer.periodic(const Duration(seconds: 3600), (_) {
        _showReminder("Time for a quick stretch & walk!");
      });
    }

    if (_waterEnabled) {
      _waterTimer = Timer.periodic(const Duration(seconds: 840), (_) {
        _showReminder("Hydration is important, Drink up.");
      });
    }

    if (_restEnabled) {
      _restTimer = Timer.periodic(const Duration(seconds: 1140), (_) {
        _showReminder("Rest your eyes for a while!");
      });
    }
  }

  void _showReminder(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.of(context).pop();
        });

        return AlertDialog(
          backgroundColor: const Color(0xFF4B0082),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Card(
      color: const Color(0xFF6A0DAD).withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.white, size: 36),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
        ),
        value: value,
        onChanged: (bool newValue) {
          setState(() {
            onChanged(newValue);
            _saveToggleStates();
            _startOrStopTimers();
          });
        },
        activeColor: Colors.amberAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trial of Temperance'),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
              child: const Center(
                child: Text(
                  'Break Bad Habits',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildToggleTile(
                    icon: Icons.directions_walk,
                    title: 'Stretch & Walk - 1hr',
                    subtitle: 'Take a 5-minute walk to refresh.',
                    value: _walkEnabled,
                    onChanged: (val) => _walkEnabled = val,
                  ),
                  const SizedBox(height: 16),
                  _buildToggleTile(
                    icon: Icons.local_drink,
                    title: 'Drink Water - 14min',
                    subtitle: 'Stay hydrated regularly.',
                    value: _waterEnabled,
                    onChanged: (val) => _waterEnabled = val,
                  ),
                  const SizedBox(height: 16),
                  _buildToggleTile(
                    icon: Icons.visibility_off,
                    title: 'Rest Your Eyes - 19min',
                    subtitle: 'Take a screen break and relax.',
                    value: _restEnabled,
                    onChanged: (val) => _restEnabled = val,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
