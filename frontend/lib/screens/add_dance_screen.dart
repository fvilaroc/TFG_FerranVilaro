import 'package:flutter/material.dart';

import '../services/dance_service.dart';

class AddDanceScreen extends StatefulWidget {
  final String token;

  const AddDanceScreen({
    super.key,
    required this.token,
  });

  @override
  State<AddDanceScreen> createState() => _AddDanceScreenState();
}

class _AddDanceScreenState extends State<AddDanceScreen> {
  final DanceService _danceService = DanceService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _clothingController = TextEditingController();
  final TextEditingController _musicController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _regionController.dispose();
    _descriptionController.dispose();
    _videoUrlController.dispose();
    _historyController.dispose();
    _originController.dispose();
    _clothingController.dispose();
    _musicController.dispose();
    super.dispose();
  }

  Future<void> _saveDance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _danceService.saveDance(
        token: widget.token,
        name: _nameController.text.trim(),
        region: _regionController.text.trim(),
        description: _descriptionController.text.trim(),
        videoUrl: _videoUrlController.text.trim(),
        history: _historyController.text.trim(),
        origin: _originController.text.trim(),
        clothing: _clothingController.text.trim(),
        music: _musicController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Baile añadido correctamente.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al añadir el baile: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    return null;
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
          const Text(
            'Añadir baile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Completa la información del baile para añadirlo al catálogo de la aplicación.',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool required = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: required ? _requiredValidator : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: maxLines == 1 ? Icon(icon) : null,
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Nombre del baile',
              icon: Icons.music_note_rounded,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _regionController,
              label: 'Región',
              icon: Icons.place_rounded,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _descriptionController,
              label: 'Breve descripción',
              icon: Icons.description_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _videoUrlController,
              label: 'URL del vídeo',
              icon: Icons.link_rounded,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _historyController,
              label: 'Historia',
              icon: Icons.history_edu_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _originController,
              label: 'Origen',
              icon: Icons.public_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _clothingController,
              label: 'Ropa tradicional',
              icon: Icons.checkroom_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _musicController,
              label: 'Música característica',
              icon: Icons.library_music_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveDance,
                icon: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_rounded),
                label: Text(_isSaving ? 'Añadiendo...' : 'Añadir baile'),
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
            Icons.admin_panel_settings_rounded,
            color: Color(0xFFF59E0B),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Esta pantalla está pensada para administradores. Los datos añadidos aparecerán después en la lista de bailes.',
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
        title: const Text(
          'Añadir baile',
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