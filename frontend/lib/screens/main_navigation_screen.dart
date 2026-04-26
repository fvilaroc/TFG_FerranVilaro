import 'package:flutter/material.dart';

import 'home_screen.dart' as home;
import 'dances_screen.dart' as dances;
import 'ranking_screen.dart' as ranking;
import 'profile_screen.dart' as profile;

class MainNavigationScreen extends StatefulWidget {
  final String username;
  final String token;

  const MainNavigationScreen({
    super.key,
    required this.username,
    required this.token,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _goToDances() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _goToRanking() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  late final List<Widget> _screens = [
    home.HomeScreen(
      username: widget.username,
      token: widget.token,
      onGoToDances: _goToDances,
      onGoToRanking: _goToRanking,
    ),
    dances.DancesScreen(token: widget.token),
    ranking.RankingScreen(token: widget.token),
    profile.ProfileScreen(username: widget.username, token: widget.token),
  ];

  final List<String> _titles = [
    'Inicio',
    'Bailes',
    'Ranking',
    'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Bailes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}