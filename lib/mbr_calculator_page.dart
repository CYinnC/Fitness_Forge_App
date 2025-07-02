import 'package:flutter/material.dart';

class MbrCalculatorPage extends StatefulWidget {
  const MbrCalculatorPage({super.key});

  @override
  _MbrCalculatorPageState createState() => _MbrCalculatorPageState();
}

class _MbrCalculatorPageState extends State<MbrCalculatorPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _gender = 'male';
  double? _result;

  void _calculateMBR() {
    final int? age = int.tryParse(_ageController.text);
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);

    if (age == null || weight == null || height == null) {
      setState(() {
        _result = null;
      });
      return;
    }

    double mbr;
    if (_gender == 'male') {
      mbr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      mbr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    setState(() {
      _result = mbr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMR Calculator'),
        backgroundColor: const Color(0xFF4B0082),
        foregroundColor: const Color(0xFFFFD700),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Column(
              children: [
                _buildTextField(_ageController, 'Age (years)'),
                const SizedBox(height: 12),
                _buildTextField(_weightController, 'Weight (kg)'),
                const SizedBox(height: 12),
                _buildTextField(_heightController, 'Height (cm)'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Gender:', style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _gender,
                      dropdownColor: const Color(0xFF4B0082),
                      style: const TextStyle(color: Colors.white),
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateMBR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A0DAD),
                  ),
                  child: const Text(
                    'Calculate BMR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                if (_result != null)
                  Column(
                    children: [
                      Text(
                        'Your BMR is: ${_result!.toStringAsFixed(2)} Calories/day',
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4B0082), Color(0xFF6A0DAD)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'To lose weight, consume fewer calories than ${_result!.toStringAsFixed(2)}.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PressStart2P',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'To gain weight, consume more calories than ${_result!.toStringAsFixed(2)}.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PressStart2P',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
