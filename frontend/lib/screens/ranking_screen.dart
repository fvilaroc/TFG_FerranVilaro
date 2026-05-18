import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ranking_models.dart';
import '../providers/auth_provider.dart';
import '../services/ranking_service.dart';
import '../services/user_service.dart';

enum _RankingTab {
  global,
  dance,
}

class RankingScreen extends StatefulWidget {
  final String token;
  final VoidCallback? onGoHome;
  final ValueChanged<String>? onTokenChanged;

  const RankingScreen({
    super.key,
    required this.token,
    this.onGoHome,
    this.onTokenChanged,
  });

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final RankingService _rankingService = RankingService();
  final UserService _userService = UserService();

  late String _currentToken;
  late String _role;

  _RankingTab _selectedTab = _RankingTab.global;

  late Future<List<GlobalRankingEntry>> _globalRankingFuture;
  Future<List<RankingDanceOption>>? _dancesFuture;
  Future<List<DanceRankingEntry>>? _danceRankingFuture;

  int? _selectedDanceId;

  static const Color _primary = Color(0xFF7C3AED);
  static const Color _secondary = Color(0xFF2563EB);
  static const Color _background = Color(0xFFF8FAFC);
  static const Color _cardBorder = Color(0xFFE5E7EB);
  static const Color _textDark = Color(0xFF111827);
  static const Color _textMuted = Color(0xFF6B7280);

  bool get _canSeeDanceRanking {
    return _role == 'PREMIUM' || _role == 'ADMIN';
  }

  @override
  void initState() {
    super.initState();

    _currentToken = widget.token;
    _role = _extractRoleFromToken(_currentToken);

    _globalRankingFuture = _rankingService.getGlobalRanking(_currentToken);
  }

  @override
  void didUpdateWidget(covariant RankingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.token != widget.token && widget.token != _currentToken) {
      _currentToken = widget.token;
      _role = _extractRoleFromToken(_currentToken);

      _globalRankingFuture = _rankingService.getGlobalRanking(_currentToken);
      _dancesFuture = null;
      _danceRankingFuture = null;
      _selectedDanceId = null;
    }
  }

  String _normalizeRole(String role) {
    final roleText = role.toUpperCase().trim();

    if (roleText.contains('ADMIN')) return 'ADMIN';
    if (roleText.contains('PREMIUM')) return 'PREMIUM';
    if (roleText.contains('FREE')) return 'FREE';

    return roleText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFF1F5F9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildTabSelector(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _selectedTab == _RankingTab.global
                      ? _buildGlobalRanking()
                      : _buildDanceRanking(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            _primary,
            _secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -26,
            top: -32,
            child: _buildHeaderCircle(96, 0.12),
          ),
          Positioned(
            right: 30,
            bottom: -52,
            child: _buildHeaderCircle(118, 0.08),
          ),
          Positioned(
            left: -38,
            bottom: -44,
            child: _buildHeaderCircle(90, 0.08),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildHeaderIcon(),
                  const Spacer(),
                  _buildRoleChip(),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'Ranking',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                _canSeeDanceRanking
                    ? 'Consulta el ranking global o compite baile por baile.'
                    : 'Consulta tu posición global y mejora tu cuenta para competir por baile.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: 14.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      height: 62,
      width: 62,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.17),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.20),
        ),
      ),
      child: const Icon(
        Icons.emoji_events_rounded,
        color: Colors.white,
        size: 36,
      ),
    );
  }

  Widget _buildRoleChip() {
    final bool premium = _canSeeDanceRanking;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: premium
            ? Colors.white.withOpacity(0.20)
            : Colors.black.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            premium
                ? Icons.workspace_premium_rounded
                : Icons.lock_outline_rounded,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 7),
          Text(
            _role,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabButton(
            title: 'Global',
            icon: Icons.public_rounded,
            tab: _RankingTab.global,
          ),
          _buildTabButton(
            title: 'Por baile',
            icon: _canSeeDanceRanking
                ? Icons.music_note_rounded
                : Icons.lock_outline_rounded,
            tab: _RankingTab.dance,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required _RankingTab tab,
  }) {
    final bool selected = _selectedTab == tab;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          if (tab == _RankingTab.dance && !_canSeeDanceRanking) {
            _showPremiumRequiredDialog();
            return;
          }

          setState(() {
            _selectedTab = tab;

            if (tab == _RankingTab.dance) {
              _dancesFuture ??= _rankingService.getRankingDances(_currentToken);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [
                      _primary,
                      _secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _primary.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 19,
                color: selected ? Colors.white : _textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : _textMuted,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalRanking() {
    return FutureBuilder<List<GlobalRankingEntry>>(
      key: const ValueKey('global-ranking'),
      future: _globalRankingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState('Cargando ranking global...');
        }

        if (snapshot.hasError) {
          return _buildErrorState(
            message: 'Error al cargar el ranking global',
            detail: snapshot.error.toString(),
            onRetry: () {
              setState(() {
                _globalRankingFuture =
                    _rankingService.getGlobalRanking(_currentToken);
              });
            },
          );
        }

        final ranking = snapshot.data ?? [];

        return RefreshIndicator(
          color: _primary,
          onRefresh: _refreshCurrentTab,
          child: _buildRankingList<GlobalRankingEntry>(
            ranking: ranking,
            emptyMessage: 'Todavía no hay datos en el ranking global.',
            username: (entry) => entry.username,
            points: (entry) => entry.points,
            pointsLabel: 'Puntos globales',
          ),
        );
      },
    );
  }

  Widget _buildDanceRanking() {
    if (!_canSeeDanceRanking) {
      return _buildPremiumLockedState();
    }

    _dancesFuture ??= _rankingService.getRankingDances(_currentToken);

    return FutureBuilder<List<RankingDanceOption>>(
      key: const ValueKey('dance-ranking'),
      future: _dancesFuture,
      builder: (context, dancesSnapshot) {
        if (dancesSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState('Cargando bailes...');
        }

        if (dancesSnapshot.hasError) {
          return _buildErrorState(
            message: 'Error al cargar los bailes',
            detail: dancesSnapshot.error.toString(),
            onRetry: () {
              setState(() {
                _dancesFuture = _rankingService.getRankingDances(_currentToken);
              });
            },
          );
        }

        final dances = dancesSnapshot.data ?? [];

        if (dances.isEmpty) {
          return _buildEmptyState('No hay bailes disponibles.');
        }

        if (_selectedDanceId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _selectedDanceId != null) return;
            _loadDanceRanking(dances.first.id);
          });
        }

        final selectedExists =
            dances.any((dance) => dance.id == _selectedDanceId);

        return Column(
          children: [
            _buildDanceSelector(
              dances: dances,
              selectedValue: selectedExists ? _selectedDanceId : null,
            ),
            Expanded(
              child: _danceRankingFuture == null
                  ? _buildEmptyState('Selecciona un baile para ver su ranking.')
                  : FutureBuilder<List<DanceRankingEntry>>(
                      future: _danceRankingFuture,
                      builder: (context, rankingSnapshot) {
                        if (rankingSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingState(
                            'Cargando ranking del baile...',
                          );
                        }

                        if (rankingSnapshot.hasError) {
                          return _buildErrorState(
                            message: 'Error al cargar el ranking del baile',
                            detail: rankingSnapshot.error.toString(),
                            onRetry: () {
                              final danceId = _selectedDanceId;
                              if (danceId != null) {
                                _loadDanceRanking(danceId);
                              }
                            },
                          );
                        }

                        final ranking = rankingSnapshot.data ?? [];

                        return RefreshIndicator(
                          color: _primary,
                          onRefresh: _refreshCurrentTab,
                          child: _buildRankingList<DanceRankingEntry>(
                            ranking: ranking,
                            emptyMessage:
                                'Todavía no hay datos en el ranking de este baile.',
                            username: (entry) => entry.username,
                            points: (entry) => entry.points,
                            pointsLabel: 'Puntos en este baile',
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDanceSelector({
    required List<RankingDanceOption> dances,
    required int? selectedValue,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 14, 18, 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedValue,
          isExpanded: true,
          borderRadius: BorderRadius.circular(20),
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _primary,
            ),
          ),
          hint: const Text('Selecciona un baile'),
          items: dances.map((dance) {
            return DropdownMenuItem<int>(
              value: dance.id,
              child: Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          _primary,
                          _secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dance.region == null || dance.region!.isEmpty
                          ? dance.name
                          : '${dance.name} · ${dance.region}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (danceId) {
            if (danceId == null) return;
            _loadDanceRanking(danceId);
          },
        ),
      ),
    );
  }

  Widget _buildRankingList<T>({
    required List<T> ranking,
    required String emptyMessage,
    required String Function(T entry) username,
    required int Function(T entry) points,
    required String pointsLabel,
  }) {
    if (ranking.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: ranking.length,
      itemBuilder: (context, index) {
        final entry = ranking[index];
        final position = index + 1;

        return _buildRankingCard(
          position: position,
          username: username(entry),
          points: points(entry),
          pointsLabel: pointsLabel,
        );
      },
    );
  }

  Widget _buildRankingCard({
    required int position,
    required String username,
    required int points,
    required String pointsLabel,
  }) {
    final bool isTopThree = position <= 3;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isTopThree ? _getPositionColor(position).withOpacity(0.38) : _cardBorder,
          width: isTopThree ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isTopThree
                ? _getPositionColor(position).withOpacity(0.16)
                : Colors.black.withOpacity(0.045),
            blurRadius: isTopThree ? 22 : 16,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPositionAvatar(position),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        username,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16.5,
                          color: _textDark,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                    if (isTopThree) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: _getPositionColor(position),
                        size: 18,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  pointsLabel,
                  style: const TextStyle(
                    color: _textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _buildPointsPill(points, position),
        ],
      ),
    );
  }

  Widget _buildPointsPill(int points, int position) {
    final bool isTopThree = position <= 3;
    final color = isTopThree ? _getPositionColor(position) : _primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Text(
        '$points pts',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildPositionAvatar(int position) {
    final bool isTopThree = position <= 3;
    final Color color = _getPositionColor(position);

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        gradient: isTopThree
            ? LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.72),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isTopThree ? null : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: isTopThree ? Colors.white.withOpacity(0.18) : _cardBorder,
        ),
      ),
      child: Center(
        child: isTopThree
            ? Icon(
                _getPositionIcon(position),
                color: Colors.white,
                size: 28,
              )
            : Text(
                '$position',
                style: const TextStyle(
                  color: _textMuted,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  IconData _getPositionIcon(int position) {
    if (position == 1) return Icons.emoji_events_rounded;
    if (position == 2) return Icons.military_tech_rounded;
    return Icons.workspace_premium_rounded;
  }

  Color _getPositionColor(int position) {
    if (position == 1) return const Color(0xFFF59E0B);
    if (position == 2) return const Color(0xFF64748B);
    if (position == 3) return const Color(0xFFB45309);
    return _primary;
  }

  Widget _buildLoadingState(String text) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: _primary,
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                color: _textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required String detail,
    required VoidCallback onRetry,
  }) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 70),
        Center(
          child: Container(
            height: 82,
            width: 82,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFDC2626),
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          detail,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _textMuted,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Container(
            height: 96,
            width: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primary.withOpacity(0.12),
                  _secondary.withOpacity(0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _primary.withOpacity(0.10),
              ),
            ),
            child: const Icon(
              Icons.leaderboard_rounded,
              color: _primary,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _textMuted,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumLockedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _cardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 86,
                width: 86,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      _primary,
                      _secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Ranking por baile bloqueado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textDark,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Esta funcionalidad solo está disponible para usuarios Premium.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textMuted,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showPremiumRequiredDialog,
                  icon: const Icon(Icons.workspace_premium_rounded),
                  label: const Text('Mejorar cuenta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPremiumRequiredDialog() {
    bool isUpgrading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            _primary,
                            _secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Función Premium',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'El ranking por baile solo está disponible para usuarios Premium o Admin. '
                      'Si quieres acceder a esta funcionalidad, tendrás que mejorar tu cuenta.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textMuted,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isUpgrading
                                ? null
                                : () {
                                    Navigator.of(dialogContext).pop();
                                    _goHome();
                                  },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _textDark,
                              side: const BorderSide(
                                color: _cardBorder,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            child: const Text('Inicio'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isUpgrading
                                ? null
                                : () async {
                                    final authProvider =
                                        context.read<AuthProvider>();

                                    setDialogState(() {
                                      isUpgrading = true;
                                    });

                                    try {
                                      final response =
                                          await _userService.upgradeAccount(
                                        token: _currentToken,
                                      );

                                      await authProvider.updateSession(
                                        token: response.token,
                                        username: response.user.username,
                                      );

                                      if (!mounted) return;

                                      _currentToken = response.token;
                                      _role = _normalizeRole(response.user.role);

                                      widget.onTokenChanged?.call(response.token);

                                      Navigator.of(dialogContext).pop();

                                      setState(() {
                                        _selectedTab = _RankingTab.dance;
                                        _selectedDanceId = null;
                                        _danceRankingFuture = null;
                                        _dancesFuture = _rankingService
                                            .getRankingDances(_currentToken);
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Cuenta mejorada correctamente.',
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;

                                      setDialogState(() {
                                        isUpgrading = false;
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'No se pudo mejorar la cuenta: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            child: isUpgrading
                                ? const SizedBox(
                                    height: 19,
                                    width: 19,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Mejorar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _loadDanceRanking(int danceId) {
    setState(() {
      _selectedDanceId = danceId;
      _danceRankingFuture = _rankingService.getDanceRanking(
        _currentToken,
        danceId,
      );
    });
  }

  Future<void> _refreshCurrentTab() async {
    try {
      if (_selectedTab == _RankingTab.global) {
        final future = _rankingService.getGlobalRanking(_currentToken);

        setState(() {
          _globalRankingFuture = future;
        });

        await future;
      } else {
        final danceId = _selectedDanceId;

        if (danceId == null) return;

        final future = _rankingService.getDanceRanking(_currentToken, danceId);

        setState(() {
          _danceRankingFuture = future;
        });

        await future;
      }
    } catch (_) {
      // El error ya se muestra en el FutureBuilder.
    }
  }

  void _goHome() {
    if (widget.onGoHome != null) {
      widget.onGoHome!();
      return;
    }

    Navigator.of(context).maybePop();
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
}