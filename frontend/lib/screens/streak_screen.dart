import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/user_service.dart';

class StreakScreen extends StatefulWidget {
  final String token;

  const StreakScreen({
    super.key,
    required this.token,
  });

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  final UserService _userService = UserService();

  UserProfile? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await _userService.getMyProfile(widget.token);

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'No se pudo cargar tu racha.';
        _isLoading = false;
      });
    }
  }

  double _getFlameSize(int streak) {
    if (streak <= 0) return 84;
    if (streak == 1) return 104;
    if (streak == 2) return 124;
    if (streak == 3) return 144;
    if (streak == 4) return 164;
    return 184;
  }

  Color _getFlameColor(int streak) {
    if (streak <= 5) return const Color(0xFFEF4444);
    if (streak <= 10) return const Color(0xFF8B5CF6);
    if (streak <= 15) return const Color(0xFF2563EB);
    if (streak <= 20) return const Color(0xFF10B981);
    if (streak <= 25) return const Color(0xFFF59E0B);
    return const Color(0xFFEC4899);
  }

  String _getMotivation(int streak) {
    if (streak <= 0) return 'Empieza hoy y crea tu primera racha.';
    if (streak <= 5) return 'Buen comienzo, sigue entrando cada día.';
    if (streak <= 10) return 'Estás cogiendo ritmo, no lo pierdas.';
    if (streak <= 15) return 'Tu constancia empieza a notarse.';
    if (streak <= 20) return 'Vas imparable, mantén la llama viva.';
    return 'Eres una leyenda del baile.';
  }

  String _getLevelName(int streak) {
    if (streak <= 0) return 'Sin racha';
    if (streak <= 5) return 'Inicio fuerte';
    if (streak <= 10) return 'Ritmo constante';
    if (streak <= 15) return 'Bailarín aplicado';
    if (streak <= 20) return 'Imparable';
    return 'Leyenda';
  }

  int _daysToNextColor(int streak) {
    if (streak <= 0) return 1;
    final nextMilestone = ((streak ~/ 5) + 1) * 5;
    return nextMilestone - streak;
  }

  Widget _buildHeader(int streak) {
    final flameColor = _getFlameColor(streak);

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
          const SizedBox(height: 18),
          Text(
            'Llevas $streak día${streak == 1 ? '' : 's'} de racha',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _getMotivation(streak),
            style: TextStyle(
              color: Colors.white.withOpacity(0.94),
              fontSize: 15,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildHeaderChip(
                icon: Icons.local_fire_department_rounded,
                text: _getLevelName(streak),
              ),
              _buildHeaderChip(
                icon: Icons.calendar_today_rounded,
                text: '$streak días',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? Colors.white),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlameCard(int streak) {
    final flameColor = _getFlameColor(streak);
    final flameSize = _getFlameSize(streak);
    final daysToNextColor = _daysToNextColor(streak);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: flameColor.withOpacity(0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  flameColor.withOpacity(0.22),
                  flameColor.withOpacity(0.06),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.local_fire_department_rounded,
                size: flameSize,
                color: flameColor,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _getLevelName(streak),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            streak <= 0
              ? 'Entra mañana para empezar a construir una racha.'
              : streak >= 25
                ? 'Has alcanzado el nivel máximo de racha. Sigue así, eres una auténtica leyenda.'
                : 'Te faltan $daysToNextColor día${daysToNextColor == 1 ? '' : 's'} para alcanzar el siguiente cambio de color.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.45,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(int streak) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFF59E0B),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Consejo: abre la app cada día para mantener tu racha activa y seguir acumulando puntos.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final streak = _profile?.streak ?? 0;

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          _buildHeader(streak),
          const SizedBox(height: 22),
          _buildFlameCard(streak),
          const SizedBox(height: 22),
          _buildInfoCard(streak),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
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
              _errorMessage ?? 'Ha ocurrido un error inesperado.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _loadProfile,
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _profile == null) {
      return _buildErrorView();
    }

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
      child: _buildContent(),
    );
  }
}