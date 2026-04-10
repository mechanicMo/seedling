import 'package:flutter/material.dart';
import 'package:seedling/core/theme/app_theme.dart';

class GuidedStepsWidget extends StatefulWidget {
  const GuidedStepsWidget({
    required this.content,
    required this.onDone,
    super.key,
  });

  final Map<String, dynamic> content;
  final VoidCallback onDone;

  @override
  State<GuidedStepsWidget> createState() => _GuidedStepsWidgetState();
}

class _GuidedStepsWidgetState extends State<GuidedStepsWidget> {
  int _currentStep = 0;

  List<Map<String, String>> get _steps {
    final steps = widget.content['steps'] as List?;
    return steps
        ?.map((s) => {
              'icon': s['icon']?.toString() ?? '',
              'text': s['text']?.toString() ?? '',
            })
        .toList() ??
        [];
  }

  String get _intro => widget.content['intro']?.toString() ?? '';
  String get _outro => widget.content['outro']?.toString() ?? '';

  bool get _isLastStep => _currentStep == _steps.length - 1;
  bool get _isStarted => _currentStep > 0;

  void _nextStep() {
    if (_isLastStep) {
      widget.onDone();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps;

    if (steps.isEmpty) {
      return Center(
        child: Text('No steps',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final currentStep = steps[_currentStep];
    final icon = currentStep['icon'] ?? '';
    final text = currentStep['text'] ?? '';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Step counter
          Text(
            'Step ${_currentStep + 1} of ${steps.length}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          // Icon
          Text(
            icon,
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 32),
          // Step text
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Navigation buttons
          Row(
            children: [
              if (_isStarted)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: AppColors.textSecondary,
                        width: 2,
                      ),
                    ),
                    onPressed: _prevStep,
                    child: const Text('← Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
              if (_isStarted) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seedGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _nextStep,
                  child: Text(
                    _isLastStep ? 'All done! 🌱' : 'Next Step →',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
