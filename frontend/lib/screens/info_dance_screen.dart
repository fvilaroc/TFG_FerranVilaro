import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dance.dart';
import '../providers/auth_provider.dart';
import '../services/user_dance_progress_service.dart';
import '../services/user_service.dart';

class InfoDanceScreen extends StatefulWidget {
  final Dance dance;
  final String token;

  const InfoDanceScreen({
    super.key,
    required this.dance,
    required this.token,
  });

  @override
  State<InfoDanceScreen> createState() => _InfoDanceScreenState();
}

class _InfoDanceScreenState extends State<InfoDanceScreen> {
  final UserDanceProgressService _progressService = UserDanceProgressService();
  final UserService _userService = UserService();

  late String _currentToken;
  late String _currentRole;

  bool _isLoadingReadStatus = true;
  bool _isMarkingAsRead = false;
  bool _hasReadDocumentation = false;
  bool _isUpgrading = false;
  String? _readStatusError;

  bool get _isFreeUser {
    return _currentRole == 'FREE';
  }

  @override
  void initState() {
    super.initState();

    _currentToken = widget.token;
    _currentRole = _extractRoleFromToken(_currentToken);

    _loadDocumentationReadStatus();
  }

  Future<void> _loadDocumentationReadStatus() async {
    setState(() {
      _isLoadingReadStatus = true;
      _readStatusError = null;
    });

    try {
      final isRead = await _progressService.isDocumentationRead(
        token: _currentToken,
        danceId: widget.dance.id,
      );

      if (!mounted) return;

      setState(() {
        _hasReadDocumentation = isRead;
        _isLoadingReadStatus = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _readStatusError = 'No se pudo comprobar el estado de lectura.';
        _isLoadingReadStatus = false;
      });
    }
  }

  Future<void> _markDocumentationAsRead() async {
    if (_isMarkingAsRead) return;

    setState(() {
      _isMarkingAsRead = true;
    });

    try {
      await _progressService.markDocumentationRead(
        token: _currentToken,
        danceId: widget.dance.id,
      );

      if (!mounted) return;

      setState(() {
        _hasReadDocumentation = true;
        _isMarkingAsRead = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Documentación marcada como leída. +20 puntos'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isMarkingAsRead = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo marcar como leído: $e'),
        ),
      );
    }
  }

  Future<void> _upgradeAccount() async {
    if (_isUpgrading) return;

    final authProvider = context.read<AuthProvider>();

    setState(() {
      _isUpgrading = true;
    });

    try {
      final response = await _userService.upgradeAccount(
        token: _currentToken,
      );

      await authProvider.updateSession(
        token: response.token,
        username: response.user.username,
      );

      if (!mounted) return;

      setState(() {
        _currentToken = response.token;
        _currentRole = _normalizeRole(response.user.role);
        _isUpgrading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta mejorada correctamente.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isUpgrading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo mejorar la cuenta: $e'),
        ),
      );
    }
  }

  String _safeText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Información no disponible.';
    }
    return value.trim();
  }

  String _normalizeRole(String role) {
    final roleText = role.toUpperCase().trim();

    if (roleText.contains('ADMIN')) return 'ADMIN';
    if (roleText.contains('PREMIUM')) return 'PREMIUM';
    if (roleText.contains('FREE')) return 'FREE';

    return roleText;
  }

  String _extractRoleFromToken(String token) {
    try {
      final parts = token.split('.');

      if (parts.length != 3) return 'FREE';

      final payload = jsonDecode(
        utf8.decode(
          base64Url.decode(
            base64Url.normalize(parts[1]),
          ),
        ),
      );

      final rawRole = payload['scope'] ??
          payload['role'] ??
          payload['roles'] ??
          payload['authorities'] ??
          '';

      final roleText = rawRole.toString().toUpperCase();

      if (roleText.contains('ADMIN')) return 'ADMIN';
      if (roleText.contains('PREMIUM')) return 'PREMIUM';
      return 'FREE';
    } catch (_) {
      return 'FREE';
    }
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
          const SizedBox(height: 18),
          Text(
            widget.dance.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Región: ${widget.dance.region}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.94),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionCard() {
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
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF97316),
                  Color(0xFFEF4444),
                ],
              ),
            ),
            child: const Icon(
              Icons.place_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Región de origen',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.dance.region,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
    Color iconColor = const Color(0xFF7C3AED),
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _detailCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader(
            icon: icon,
            title: title,
            iconColor: iconColor,
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF374151),
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtectedDetailCard({
    required IconData icon,
    required String title,
    required String content,
    required String premiumMessage,
    Color iconColor = const Color(0xFF7C3AED),
  }) {
    if (!_isFreeUser) {
      return _buildDetailCard(
        icon: icon,
        title: title,
        content: content,
        iconColor: iconColor,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _detailCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader(
            icon: icon,
            title: title,
            iconColor: iconColor,
          ),
          const SizedBox(height: 14),
          _buildBlurredContentOnly(
            premiumMessage: premiumMessage,
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF374151),
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailHeader({
    required IconData icon,
    required String title,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _detailCardDecoration() {
    return BoxDecoration(
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
    );
  }

  Widget _buildVideoCard() {
    final videoUrl = _safeText(widget.dance.videoUrl);

    if (_isFreeUser) {
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
          children: [
            const Icon(
              Icons.play_circle_fill_rounded,
              color: Color(0xFFEF4444),
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'URL del vídeo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildBlurredContentOnly(
                    premiumMessage: 'Mejorar a Premium para ver el vídeo',
                    child: Text(
                      videoUrl,
                      style: const TextStyle(
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
        children: [
          const Icon(
            Icons.play_circle_fill_rounded,
            color: Color(0xFFEF4444),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'URL del vídeo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  videoUrl,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredContentOnly({
    required Widget child,
    required String premiumMessage,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 4.5,
              sigmaY: 4.5,
            ),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 72,
              ),
              padding: const EdgeInsets.all(2),
              child: child,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.64),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildPremiumButton(premiumMessage),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumButton(String text) {
    return ElevatedButton.icon(
      onPressed: _isUpgrading ? null : _upgradeAccount,
      icon: _isUpgrading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Colors.white,
              ),
            )
          : const Icon(
              Icons.workspace_premium_rounded,
              size: 18,
            ),
      label: Text(
        _isUpgrading ? 'Mejorando...' : text,
        textAlign: TextAlign.center,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildReadDocumentationButton() {
    if (_isLoadingReadStatus) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: const Row(
          children: [
            SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Color(0xFF7C3AED),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'Comprobando si ya has leído esta documentación...',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_readStatusError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFFED7AA),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF97316),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _readStatusError!,
                style: const TextStyle(
                  color: Color(0xFF9A3412),
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
            IconButton(
              onPressed: _loadDocumentationReadStatus,
              icon: const Icon(
                Icons.refresh_rounded,
                color: Color(0xFFF97316),
              ),
            ),
          ],
        ),
      );
    }

    if (_hasReadDocumentation) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isMarkingAsRead ? null : _markDocumentationAsRead,
        icon: _isMarkingAsRead
            ? const SizedBox(
                height: 21,
                width: 21,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.check_circle_rounded),
        label: Text(
          _isMarkingAsRead
              ? 'Marcando como leído...'
              : 'Marcar documentación como leída',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dance = widget.dance;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          dance.name,
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
      body: Container(
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
        child: RefreshIndicator(
          color: const Color(0xFF7C3AED),
          onRefresh: _loadDocumentationReadStatus,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              _buildHeader(),
              const SizedBox(height: 22),

              _buildRegionCard(),
              const SizedBox(height: 16),

              _buildDetailCard(
                icon: Icons.description_rounded,
                title: 'Descripción',
                content: _safeText(dance.description),
              ),
              const SizedBox(height: 16),

              _buildDetailCard(
                icon: Icons.history_edu_rounded,
                title: 'Historia',
                content: _safeText(dance.history),
                iconColor: const Color(0xFFF97316),
              ),
              const SizedBox(height: 16),

              _buildDetailCard(
                icon: Icons.public_rounded,
                title: 'Origen',
                content: _safeText(dance.origin),
                iconColor: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 16),

              _buildDetailCard(
                icon: Icons.checkroom_rounded,
                title: 'Ropa tradicional',
                content: _safeText(dance.clothing),
                iconColor: const Color(0xFF10B981),
              ),
              const SizedBox(height: 16),

              _buildDetailCard(
                icon: Icons.library_music_rounded,
                title: 'Música característica',
                content: _safeText(dance.musicCharacteristics),
                iconColor: const Color(0xFF8B5CF6),
              ),
              const SizedBox(height: 16),

              _buildProtectedDetailCard(
                icon: Icons.directions_walk_rounded,
                title: 'Pasos de baile',
                content: _safeText(dance.danceSteps),
                premiumMessage: 'Mejorar a Premium para ver los pasos',
                iconColor: const Color(0xFFEC4899),
              ),
              const SizedBox(height: 16),

              _buildVideoCard(),
              const SizedBox(height: 22),

              _buildReadDocumentationButton(),
            ],
          ),
        ),
      ),
    );
  }
}