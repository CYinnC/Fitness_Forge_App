import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GuideHandbookPage extends StatefulWidget {
  const GuideHandbookPage({super.key});

  @override
  _GuideHandbookPageState createState() => _GuideHandbookPageState();
}

class _GuideHandbookPageState extends State<GuideHandbookPage> {
  List<dynamic> _exercises = [];
  List<dynamic> _categories = [];
  List<dynamic> _equipment = [];
  List<dynamic> _muscles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  Future<void> _fetchData() async {
    try {
      final exerciseResponse = await http.get(Uri.parse('https://wger.de/api/v2/exercise/'));
      final categoryResponse = await http.get(Uri.parse('https://wger.de/api/v2/exercisecategory/'));
      final equipmentResponse = await http.get(Uri.parse('https://wger.de/api/v2/equipment/'));
      final muscleResponse = await http.get(Uri.parse('https://wger.de/api/v2/muscle/'));

      if (exerciseResponse.statusCode == 200 &&
          categoryResponse.statusCode == 200 &&
          equipmentResponse.statusCode == 200 &&
          muscleResponse.statusCode == 200) {
        final exerciseData = json.decode(exerciseResponse.body);
        final categoryData = json.decode(categoryResponse.body);
        final equipmentData = json.decode(equipmentResponse.body);
        final muscleData = json.decode(muscleResponse.body);

        setState(() {
          _exercises = exerciseData['results'];
          _categories = categoryData['results'];
          _equipment = equipmentData['results'];
          _muscles = muscleData['results'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching data: $e");
      throw Exception('Error fetching data');
    }
  }

  // Method to resolve category ID to name
  String _getCategoryName(int? categoryId) {
    if (categoryId == null) return 'Unknown Category';
    final category = _categories.firstWhere(
          (cat) => cat['id'] == categoryId,
      orElse: () => {'name': 'Unknown Category'},
    );
    return category['name'] ?? 'Unknown Category';
  }

  // Method to resolve equipment ID to name
  String _getEquipmentName(int? equipmentId) {
    if (equipmentId == null) return 'Unknown Equipment';
    final equipment = _equipment.firstWhere(
          (equip) => equip['id'] == equipmentId,
      orElse: () => {'name': 'Unknown Equipment'},
    );
    return equipment['name'] ?? 'Unknown Equipment';
  }

  // Method to resolve muscle ID to name
  String _getMuscleName(int? muscleId) {
    if (muscleId == null) return 'Unknown Muscle';
    final muscle = _muscles.firstWhere(
          (mus) => mus['id'] == muscleId,
      orElse: () => {'name': 'Unknown Muscle'},
    );
    return muscle['name'] ?? 'Unknown Muscle';
  }

  Future<Map<String, dynamic>> _fetchExerciseDetails(int exerciseId) async {
    try {
      final response = await http.get(Uri.parse('https://wger.de/api/v2/exerciseinfo/$exerciseId/'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load exercise details');
      }
    } catch (e) {
      print("Error fetching exercise details: $e");
      return {};
    }
  }

  // Method to fetch translated name for the exercise
  Future<String?> _fetchExerciseName(int exerciseId) async {
    final exerciseDetails = await _fetchExerciseDetails(exerciseId);
    final translations = exerciseDetails['translations'] ?? [];
    final translation = translations.isNotEmpty
        ? translations.firstWhere(
            (t) => t['language'] == 2,
        orElse: () => translations.first)
        : {};
    return translation['name'] ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Handbook'),
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _exercises.length,
            itemBuilder: (context, index) {
              final exercise = _exercises[index];


              final exerciseId = exercise['id'];
              return FutureBuilder<String?>(
                future: _fetchExerciseName(exerciseId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final exerciseName = snapshot.data ?? 'No Name';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFFFFD700), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: const Color(0xFF800080),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        exerciseName,
                        style: const TextStyle(
                          color: Color(0xFFFBFBFB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        _showExerciseDetails(exercise, exerciseName);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Show exercise details in a dialog when tapped
  void _showExerciseDetails(Map<String, dynamic> exercise, String exerciseName) async {
    final categoryName = _getCategoryName(exercise['category']);
    final equipmentNames = exercise['equipment']
        .map((equipId) => _getEquipmentName(equipId))
        .join(', ');
    final muscleNames = exercise['muscles']?.map((musId) => _getMuscleName(musId))?.join(', ') ?? 'No muscles listed';

    // Fetch additional details from the /exerciseinfo/ endpoint
    final exerciseId = exercise['id'];
    final exerciseDetails = await _fetchExerciseDetails(exerciseId);

    // Extract translated description from the 'translations' field
    final translations = exerciseDetails['translations'] ?? [];
    final translation = translations.isNotEmpty
        ? translations.firstWhere(
            (t) => t['language'] == 2, // Assuming '2' is the language code for English
        orElse: () => translations.first)
        : {};

    final exerciseDescription = translation['description'] ?? 'No description available';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(exerciseName),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: $categoryName'),
                Text('Equipment: $equipmentNames'),
                Text('Muscles: $muscleNames'),
                const SizedBox(height: 10),
                Text('Description: $exerciseDescription'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
