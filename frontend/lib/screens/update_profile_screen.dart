import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

import '../services/user_service.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String token;

  const UpdateProfileScreen({
    super.key,
    required this.token,
  });

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final UserService _userService = UserService();
  final TextEditingController _valueController = TextEditingController();

  String _selectedField = 'username';
  bool _isSaving = false;

  final Map<String, String> _fieldLabels = {
    'username': 'Username',
    'email': 'Correo electrónico',
    'password': 'Contraseña',
  };

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final value = _valueController.text.trim();

    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduce un valor válido.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (_selectedField == 'username') {
        final response = await _userService.updateUsername(
          token: widget.token,
          newUsername: value,
        );

        await context.read<AuthProvider>().updateSession(
          token: response.token,
          username: response.user.username,
        );
      } else if (_selectedField == 'email') {
        await _userService.updateEmail(
          token: widget.token,
          newEmail: value,
        );
      } else {
        await _userService.updatePassword(
          token: widget.token,
          newPassword: value,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil modificado correctamente.'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al modificar el perfil: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });
    }
  }

  String _getHintText() {
    if (_selectedField == 'username') return 'Introduce el nuevo username';
    if (_selectedField == 'email') return 'Introduce el nuevo correo';
    return 'Introduce la nueva contraseña';
  }

  IconData _getIcon() {
    if (_selectedField == 'username') return Icons.person_rounded;
    if (_selectedField == 'email') return Icons.email_rounded;
    return Icons.lock_rounded;
  }

  bool _isPasswordField() {
    return _selectedField == 'password';
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Perfil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Modificar perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Selecciona el dato que quieres cambiar e introduce el nuevo valor.',
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

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
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
        children: [
          DropdownButtonFormField<String>(
            value: _selectedField,
            decoration: InputDecoration(
              labelText: 'Campo a modificar',
              prefixIcon: const Icon(Icons.tune_rounded),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            items: _fieldLabels.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _selectedField = value;
                _valueController.clear();
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _valueController,
            obscureText: _isPasswordField(),
            keyboardType: _selectedField == 'email'
                ? TextInputType.emailAddress
                : TextInputType.text,
            decoration: InputDecoration(
              labelText: _getHintText(),
              prefixIcon: Icon(_getIcon()),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xFF7C3AED),
                  width: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _updateProfile,
              icon: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(_isSaving ? 'Guardando...' : 'Guardar cambios'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
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
            Icons.info_rounded,
            color: Color(0xFFF59E0B),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Si modificas el username, el backend devuelve un nuevo token para mantener la sesión actualizada.',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: const Text(
          'Modificar perfil',
          style: TextStyle(
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
            _buildFormCard(),
            const SizedBox(height: 18),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }
}