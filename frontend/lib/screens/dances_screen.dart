import 'package:flutter/material.dart';

import '../models/dance.dart';
import '../models/user_profile.dart';
import '../services/dance_service.dart';
import '../services/user_service.dart';
import 'add_dance_screen.dart';
import 'info_dance_screen.dart';

class DancesScreen extends StatefulWidget {
  final String token;

  const DancesScreen({
    super.key,
    required this.token,
  });

  @override
  State<DancesScreen> createState() => _DancesScreenState();
}

class _DancesScreenState extends State<DancesScreen> {
  final DanceService _danceService = DanceService();
  final UserService _userService = UserService();

  late Future<List<Dance>> _dancesFuture;

  UserProfile? _profile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _dancesFuture = _danceService.getAllDances(widget.token);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _userService.getMyProfile(widget.token);

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  bool get _isAdmin {
    final role = _profile?.role.toUpperCase().trim() ?? '';
    return role.contains('ADMIN');
  }

  Future<void> _refreshDances() async {
    setState(() {
      _dancesFuture = _danceService.getAllDances(widget.token);
    });
  }

  Future<void> _goToAddDance() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddDanceScreen(token: widget.token),
      ),
    );

    if (created == true) {
      _refreshDances();
    }
  }

  void _goToDanceInfo(Dance dance) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InfoDanceScreen(
          dance: dance,
          token: widget.token,
        ),
      ),
    );
  }

  IconData _getDanceIcon(int index) {
    final icons = [
      Icons.music_note_rounded,
      Icons.festival_rounded,
      Icons.theater_comedy_rounded,
      Icons.celebration_rounded,
      Icons.auto_awesome_rounded,
    ];

    return icons[index % icons.length];
  }

  List<Color> _getCardGradient(int index) {
    final gradients = [
      [const Color(0xFFF97316), const Color(0xFFEF4444)],
      [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
      [const Color(0xFF0EA5E9), const Color(0xFF2563EB)],
      [const Color(0xFF10B981), const Color(0xFF059669)],
      [const Color(0xFFF59E0B), const Color(0xFFEA580C)],
    ];

    return gradients[index % gradients.length];
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF2563EB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              if (!_isLoadingProfile && _isAdmin)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _goToAddDance,
                    borderRadius: BorderRadius.circular(999),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Añadir',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Explora los bailes típicos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Descubre bailes tradicionales de España, conoce su origen, su región y accede a la información detallada de cada uno.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.94),
              fontSize: 14.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDanceCard({
    required Dance dance,
    required int index,
  }) {
    final gradient = _getCardGradient(index);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _goToDanceInfo(dance),
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient.last.withOpacity(0.23),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    _getDanceIcon(index),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dance.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Región: ${dance.region}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.94),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        dance.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 13.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los bailes:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _refreshDances,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Column(
            children: [
              Icon(
                Icons.music_off_rounded,
                size: 54,
                color: Color(0xFF9CA3AF),
              ),
              SizedBox(height: 14),
              Text(
                'Todavía no hay bailes cargados',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Cuando haya bailes disponibles, aparecerán en esta pantalla.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDancesList(List<Dance> dances) {
    return RefreshIndicator(
      onRefresh: _refreshDances,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        itemCount: dances.length + 2,
        separatorBuilder: (_, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }

          if (index == 1) {
            return const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 2),
              child: Text(
                'Selecciona un baile',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            );
          }

          final danceIndex = index - 2;
          final dance = dances[danceIndex];

          return _buildDanceCard(
            dance: dance,
            index: danceIndex,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF8FAFC),
            Color(0xFFF3F4F6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: FutureBuilder<List<Dance>>(
        future: _dancesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorView(snapshot.error!);
          }

          final dances = snapshot.data ?? [];

          if (dances.isEmpty) {
            return _buildEmptyView();
          }

          return _buildDancesList(dances);
        },
      ),
    );
  }
}