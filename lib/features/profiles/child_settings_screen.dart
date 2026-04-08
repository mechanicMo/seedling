import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

class ChildSettingsScreen extends ConsumerStatefulWidget {
  const ChildSettingsScreen({required this.childId, super.key});
  final String childId;

  @override
  ConsumerState<ChildSettingsScreen> createState() =>
      _ChildSettingsScreenState();
}

class _ChildSettingsScreenState extends ConsumerState<ChildSettingsScreen> {
  static const _timerOptions = [10, 15, 20, 25, 30, 45, 60];

  static const _activityLabels = {
    'story': '📖 Stories',
    'game': '🎮 Games',
    'music': '🎵 Music',
  };

  ChildProfile? _profile;
  int _timerMinutes = AppConstants.defaultSessionTimerMinutes;
  List<String> _enabledTypes = List.from(AppConstants.v1ActivityTypes);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  void _loadProfile() {
    final profiles = ref.read(childProfilesProvider).valueOrNull ?? [];
    final profile = profiles.where((p) => p.id == widget.childId).firstOrNull;
    if (profile != null && mounted) {
      setState(() {
        _profile = profile;
        _timerMinutes = profile.sessionTimerMinutes;
        _enabledTypes = List.from(
          profile.contentSelection.enabledActivityTypes,
        );
      });
    }
  }

  Future<void> _save(ChildProfile updated) async {
    await ref.read(childProfilesNotifierProvider.notifier).update(updated);
  }

  void _onTimerChanged(int minutes) {
    if (_profile == null) return;
    setState(() => _timerMinutes = minutes);
    _save(_profile!.copyWith(sessionTimerMinutes: minutes));
  }

  void _onTypeToggled(String type, bool enabled) {
    if (_profile == null) return;
    final updated = enabled
        ? [..._enabledTypes, type]
        : _enabledTypes.where((t) => t != type).toList();
    setState(() => _enabledTypes = updated);
    _save(_profile!.copyWith(
      contentSelection: _profile!.contentSelection.copyWith(
        enabledActivityTypes: updated,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Keep local state in sync with real-time stream updates
    ref.listen(childProfilesProvider, (_, next) {
      final profiles = next.valueOrNull ?? [];
      final profile =
          profiles.where((p) => p.id == widget.childId).firstOrNull;
      if (profile != null && profile != _profile) {
        setState(() {
          _profile = profile;
          _timerMinutes = profile.sessionTimerMinutes;
          _enabledTypes =
              List.from(profile.contentSelection.enabledActivityTypes);
        });
      }
    });

    final name = _profile?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(name.isEmpty ? 'Settings' : "$name's Settings"),
      ),
      body: _profile == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _SectionHeader(label: 'Screen Time Limit'),
                const SizedBox(height: 4),
                Text(
                  'How long each session lasts before automatically ending.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _timerOptions.map((minutes) {
                    final selected = _timerMinutes == minutes;
                    return ChoiceChip(
                      label: Text('$minutes min'),
                      selected: selected,
                      selectedColor: AppColors.seedGreen,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => _onTimerChanged(minutes),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                _SectionHeader(label: 'Activity Types'),
                const SizedBox(height: 4),
                Text(
                  'Choose which kinds of activities appear in your child\'s session.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                for (final type in AppConstants.v1ActivityTypes)
                  _ActivityToggle(
                    label: _activityLabels[type] ?? type,
                    enabled: _enabledTypes.contains(type),
                    // Disable the toggle if it's the last one on
                    canToggle: !(_enabledTypes.contains(type) &&
                        _enabledTypes.length == 1),
                    onChanged: (val) => _onTypeToggled(type, val),
                  ),
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _ActivityToggle extends StatelessWidget {
  const _ActivityToggle({
    required this.label,
    required this.enabled,
    required this.canToggle,
    required this.onChanged,
  });

  final String label;
  final bool enabled;
  final bool canToggle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      value: enabled,
      onChanged: canToggle ? onChanged : null,
      activeColor: AppColors.seedGreen,
      contentPadding: EdgeInsets.zero,
    );
  }
}
