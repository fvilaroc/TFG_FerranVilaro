import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String token;
  final VoidCallback onGoToDances;
  final VoidCallback onGoToRanking;

  const HomeScreen({
    super.key,
    required this.username,
    required this.token,
    required this.onGoToDances,
    required this.onGoToRanking,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();

  UserProfile? _profile;
  bool _isLoadingProfile = true;
  bool _isUpgrading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoadingProfile = true;
      _errorMessage = null;
    });

    try {
      final profile = await _userService.getMyProfile(widget.token);

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _isLoadingProfile = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'No se pudo cargar el perfil.';
        _isLoadingProfile = false;
      });
    }
  }

  String get _normalizedRole {
    final role = _profile?.role.toUpperCase().trim() ?? '';

    if (role.contains('ADMIN')) return 'ADMIN';
    if (role.contains('PREMIUM')) return 'PREMIUM';
    if (role.contains('FREE')) return 'FREE';

    return role;
  }

  bool get _isPremiumOrAdmin {
    return _normalizedRole == 'PREMIUM' || _normalizedRole == 'ADMIN';
  }

  String _formatRole(String? role) {
    if (role == null || role.isEmpty) return 'Usuario';
    if (role.contains('_')) return role.split('_').last;
    return role;
  }

  Future<void> _handleTestsPressed() async {
    if (_profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todavía se está cargando el perfil del usuario.'),
        ),
      );
      return;
    }

    if (!_isPremiumOrAdmin) {
      _showPremiumDialog();
      return;
    }

    _goToQuizScreen();
  }

  void _goToQuizScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(token: widget.token),
      ),
    );
  }

  Future<void> _upgradeAccount() async {
    if (_isUpgrading) return;

    setState(() {
      _isUpgrading = true;
    });

    try {
      final response = await http.patch(
        Uri.parse('${AppConfig.baseUrl}/users/upgrade'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await _loadProfile();

        if (!mounted) return;

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tu cuenta se ha mejorado correctamente.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error ${response.statusCode}: ${response.body}',
            ),
            //content: Text('No se pudo mejorar la cuenta: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ha ocurrido un error al mejorar la cuenta.'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isUpgrading = false;
      });
    }
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      barrierDismissible: !_isUpgrading,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: const [
              Icon(Icons.lock_outline, color: Color(0xFF7C3AED)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Contenido PREMIUM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            'La pantalla de tests es solo para usuarios PREMIUM. '
            'Si quieres acceder a esta funcionalidad, debes mejorar tu cuenta.',
            style: TextStyle(height: 1.4),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isUpgrading
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Volver a inicio'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUpgrading ? null : _upgradeAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isUpgrading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Mejorar cuenta'),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getFlameSize(int streak) {
    if (streak <= 0) return 28;
    if (streak == 1) return 34;
    if (streak == 2) return 42;
    if (streak == 3) return 50;
    if (streak == 4) return 58;
    return 66;
  }

  Color _getFlameColor(int streak) {
    if (streak <= 5) return Colors.red;
    if (streak <= 10) return const Color(0xFF8B5CF6);
    if (streak <= 15) return const Color(0xFF2563EB);
    if (streak <= 20) return const Color(0xFF10B981);
    if (streak <= 25) return const Color(0xFFF59E0B);
    return const Color(0xFFEC4899);
  }

  String _getStreakLabel(int streak) {
    if (streak <= 0) return 'Empieza tu racha hoy';
    if (streak <= 5) return 'Buen comienzo';
    if (streak <= 10) return 'Vas muy bien';
    if (streak <= 15) return 'Ritmo excelente';
    if (streak <= 20) return 'Imparable';
    return 'Leyenda del baile';
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient.last.withOpacity(0.25),
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
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.92),
                          fontSize: 13.5,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
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

  Widget _buildStreakCard() {
    final streak = _profile?.streak ?? 0;
    final flameColor = _getFlameColor(streak);
    final flameSize = _getFlameSize(streak);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: flameColor.withOpacity(0.18),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: flameColor.withOpacity(0.10),
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: flameColor,
              size: flameSize,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tu racha actual',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$streak día${streak == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getStreakLabel(streak),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBanner() {
    final username =
        _profile?.username.isNotEmpty == true ? _profile!.username : widget.username;

    final role = _formatRole(_profile?.role);

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Inicio',
              style: TextStyle(
                color: Colors.white.withOpacity(0.98),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Bienvenido, $username',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Descubre los bailes típicos de España, aprende su historia, '
            'mejora con los tests y compite en los rankings mientras mantienes tu racha diaria.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.94),
              fontSize: 14.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildInfoChip(
                icon: Icons.workspace_premium_rounded,
                text: role,
              ),
              _buildInfoChip(
                icon: Icons.stars_rounded,
                text: '${_profile?.points ?? 0} puntos',
              ),
              _buildInfoChip(
                icon: Icons.local_fire_department_rounded,
                text: '${_profile?.streak ?? 0} de racha',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
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

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          _buildTopBanner(),
          const SizedBox(height: 22),
          _buildStreakCard(),
          const SizedBox(height: 22),
          const Text(
            '¿Qué quieres hacer hoy?',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Accede rápidamente a las funcionalidades principales de la aplicación.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          _buildActionButton(
            icon: Icons.music_note_rounded,
            title: 'Bailes',
            subtitle: 'Explora los bailes típicos y descubre su historia.',
            gradient: const [
              Color(0xFFF97316),
              Color(0xFFEF4444),
            ],
            onTap: widget.onGoToDances,
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.quiz_rounded,
            title: 'Tests',
            subtitle: !_isPremiumOrAdmin
                ? 'Disponible solo para usuarios PREMIUM.'
                : 'Pon a prueba tus conocimientos y gana puntos.',
            gradient: const [
              Color(0xFF8B5CF6),
              Color(0xFF6366F1),
            ],
            onTap: _handleTestsPressed,
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.emoji_events_rounded,
            title: 'Rankings',
            subtitle: 'Consulta tu posición y compite con otros usuarios.',
            gradient: const [
              Color(0xFF0EA5E9),
              Color(0xFF2563EB),
            ],
            onTap: widget.onGoToRanking,
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE5E7EB)),
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
                    'Consejo: entra cada día para mantener tu racha y seguir subiendo en el ranking.',
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
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
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
    if (_isLoadingProfile) {
      return _buildLoadingView();
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
      child: _buildBody(),
    );
  }
}