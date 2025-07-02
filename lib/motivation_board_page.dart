import 'package:flutter/material.dart';
import 'add_motivation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MotivationBoardPage extends StatefulWidget {
  const MotivationBoardPage({super.key});

  @override
  _MotivationBoardPageState createState() => _MotivationBoardPageState();
}

class _MotivationBoardPageState extends State<MotivationBoardPage> {
  List<String> _motivationQuotes = [];


  Future<void> _loadQuotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _motivationQuotes = prefs.getStringList('motivationQuotes') ?? [];
    });
  }


  Future<void> _deleteQuote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _motivationQuotes.removeAt(index);
      prefs.setStringList('motivationQuotes', _motivationQuotes);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation Board'),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: const Center(
                child: Text(
                  'What drives you?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: _motivationQuotes.isEmpty
                  ? const Center(
                child: Text(
                  'No quotes available.',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _motivationQuotes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _motivationQuotes[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {

                        _deleteQuote(index);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MaterialButton(
                color: const Color(0xFF6A0DAD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                onPressed: () async {

                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddMotivationPage()),
                  );

                  _loadQuotes();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Add Motivational Quote +',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
