import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

class AddEditProfileScreen extends ConsumerStatefulWidget {
  const AddEditProfileScreen({super.key, this.childId});

  /// If set, we are editing an existing profile. If null, we are creating.
  final String? childId;

  @override
  ConsumerState<AddEditProfileScreen> createState() => _AddEditProfileScreenState();
}

class _AddEditProfileScreenState extends ConsumerState<AddEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  ChildProfile? _existingProfile;

  @override
  void initState() {
    super.initState();
    if (widget.childId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  void _loadExisting() {
    final profiles = ref.read(childProfilesProvider).valueOrNull ?? [];
    final profile = profiles.where((p) => p.id == widget.childId).firstOrNull;
    if (profile != null) {
      setState(() {
        _existingProfile = profile;
        _nameController.text = profile.name;
        _selectedBirthDate = profile.birthDate;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 3)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 12)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedBirthDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a birthday')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final ageRange = ChildProfile.calculateAgeRange(_selectedBirthDate!);

      if (_existingProfile != null) {
        final updated = _existingProfile!.copyWith(
          name: _nameController.text.trim(),
          birthDate: _selectedBirthDate!,
          ageRange: ageRange,
        );
        await ref.read(childProfilesNotifierProvider.notifier).update(updated);
      } else {
        final profile = ChildProfile(
          id: '',
          name: _nameController.text.trim(),
          birthDate: _selectedBirthDate!,
          ageRange: ageRange,
        );
        await ref.read(childProfilesNotifierProvider.notifier).add(profile);
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.childId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Profile' : 'Add Child')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Child's first name"),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickBirthDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Birthday'),
                    child: Text(
                      _selectedBirthDate == null
                          ? 'Tap to select'
                          : '${_selectedBirthDate!.month}/${_selectedBirthDate!.day}/${_selectedBirthDate!.year}',
                      style: TextStyle(
                        color: _selectedBirthDate == null
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(isEditing ? 'Save Changes' : 'Add Child'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
