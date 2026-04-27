import 'package:flutter/material.dart';

import 'home_screen.dart' as home;
import 'dances_screen.dart' as dances;
import 'ranking_screen.dart' as ranking;
import 'profile_screen.dart' as profile;
import 'streak_screen.dart' as streak;

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
    setState(() => _selectedIndex = 1);
  }

  void _goToRanking() {
    setState(() => _selectedIndex = 3);
  }

  late final List<Widget> _screens = [
    home.HomeScreen(
      username: widget.username,
      token: widget.token,
      onGoToDances: _goToDances,
      onGoToRanking: _goToRanking,
    ),
    dances.DancesScreen(token: widget.token),
    streak.StreakScreen(token: widget.token),
    ranking.RankingScreen(token: widget.token),
    profile.ProfileScreen(username: widget.username, token: widget.token),
  ];

  final List<String> _titles = [
    'Inicio',
    'Bailes',
    'Streak',
    'Ranking',
    'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Inicio',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.music_note_rounded,
                label: 'Bailes',
                index: 1,
              ),
              _buildFlameNavItem(),
              _buildNavItem(
                icon: Icons.emoji_events_rounded,
                label: 'Ranking',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Perfil',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF7C3AED).withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlameNavItem() {
    final isSelected = _selectedIndex == 2;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = 2),
      child: Transform.translate(
        offset: const Offset(0, -14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isSelected
                      ? const [
                          Color(0xFFEF4444),
                          Color(0xFFF97316),
                        ]
                      : const [
                          Color(0xFF7C3AED),
                          Color(0xFF2563EB),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isSelected
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF7C3AED))
                        .withOpacity(0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Streak',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF7C3AED),
              ),
            ),
          ],
        ),
      ),
    );
  }
}