import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMotivationPage extends StatefulWidget {
  const AddMotivationPage({super.key});

  @override
  _AddMotivationPageState createState() => _AddMotivationPageState();
}

class _AddMotivationPageState extends State<AddMotivationPage> {
  final TextEditingController _quoteController = TextEditingController();


  Future<void> _saveQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    List<String> savedQuotes = prefs.getStringList('motivationQuotes') ?? [];


    savedQuotes.add(_quoteController.text);


    await prefs.setStringList('motivationQuotes', savedQuotes);


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quote Forged'),
          content: const Text('Your motivational quote has been saved!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B0082),
        foregroundColor: const Color(0xFFFFD700),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Centered text
              Center(
                child: const Text(
                  'Forge your drive through words',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _quoteController,
                decoration: InputDecoration(
                  hintText: 'Enter your motivational quote',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveQuote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0DAD),
                ),
                child: const Text(
                  'Save Quote',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
