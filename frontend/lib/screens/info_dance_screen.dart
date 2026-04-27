import 'package:flutter/material.dart';

import '../models/dance.dart';

class InfoDanceScreen extends StatelessWidget {
  final Dance dance;
  final String token;

  const InfoDanceScreen({
    super.key,
    required this.dance,
    required this.token,
  });

  String _safeText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Información no disponible.';
    }
    return value.trim();
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
            dance.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Región: ${dance.region}',
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
                  dance.region,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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

  Widget _buildVideoCard() {
    final videoUrl = _safeText(dance.videoUrl);

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

  Widget _buildComingSoonCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFFF59E0B),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Más adelante esta pantalla podrá incluir videotutoriales, progreso del usuario y acceso directo a tests relacionados con este baile.',
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

  @override
  Widget build(BuildContext context) {
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
            _buildVideoCard(),
            const SizedBox(height: 16),
            _buildComingSoonCard(),
          ],
        ),
      ),
    );
  }
}