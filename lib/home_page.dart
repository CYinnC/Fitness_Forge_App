import 'package:fitness_forge_app/guide_handbook_page.dart';
import 'package:flutter/material.dart';
import 'motivation_board_page.dart';
import 'mbr_calculator_page.dart';
import 'tot_page.dart';
import 'diet_journal_page.dart';
import 'daily_fitness_quest_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: AppBar(
          title: const Center(
            child: Text('Home'),
          ),
          backgroundColor: const Color(0xFF4B0082),
          foregroundColor: const Color(0xFFFFD700),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
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
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildButton(
                context,
                label: 'Daily Fitness Quest',
                icon: Icons.fitness_center,
                color: Color(0xFF4B0082),
                backgroundImage: 'assets/images/quest.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DailyFitnessQuestPage()),
                  );
                },
              ),
              _buildButton(
                context,
                label: 'Motivation Board',
                icon: Icons.lightbulb_outline,
                color: Color(0xFF6A0DAD),
                backgroundImage: 'assets/images/board.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MotivationBoardPage()),
                  );
                },
              ),
              _buildButton(
                context,
                label: 'Diet Journal',
                icon: Icons.book,
                color: Color(0xFF8A2BE2),
                backgroundImage: 'assets/images/journal.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietJournalPage()),
                  );
                },
              ),
              _buildButton(
                context,
                label: 'BMR Calculator',
                icon: Icons.calculate,
                color: Color(0xFF7B68EE),
                backgroundImage: 'assets/images/mbr.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MbrCalculatorPage()),
                  );
                },
              ),
              _buildButton(
                context,
                label: 'Trial of Temperance',
                icon: Icons.link,
                color: Color(0xFF9B30FF),
                backgroundImage: 'assets/images/tot.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TotPage()),
                  );
                },
              ),
              _buildButton(
                context,
                label: 'Guide Handbook',
                icon: Icons.menu_book,
                color: Color(0xFF9370DB),
                backgroundImage: 'assets/images/handbook.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GuideHandbookPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required Color color,
        required VoidCallback onPressed,
        String? backgroundImage,
      }) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundImage == null ? color : null,
            borderRadius: BorderRadius.circular(12.0),
            image: backgroundImage != null
                ? DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 8.0),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
