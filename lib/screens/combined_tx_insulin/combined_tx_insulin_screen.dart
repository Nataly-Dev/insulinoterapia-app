import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/insulin_provider.dart';
import '../../widgets/insulin_result_card.dart';

class CombinedTxInsulinScreen extends ConsumerStatefulWidget {
  const CombinedTxInsulinScreen({super.key});

  @override
  ConsumerState<CombinedTxInsulinScreen> createState() =>
      _CombinedTxInsulinScreenState();
}

class _CombinedTxInsulinScreenState
    extends ConsumerState<CombinedTxInsulinScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  bool _isInverse = false;

  void _toggleInverseMode(bool value) {
    setState(() => _isInverse = value);
    _clearInputsAndResult();
  }

  void _clearInputsAndResult() {
    _weightController.clear();
    _doseController.clear();
    ref.read(insulinProvider.notifier).clear();
  }

  void _calculate() {
    final weight = double.tryParse(_weightController.text.trim().replaceAll(',', '.'));
    final dose = double.tryParse(_doseController.text.trim().replaceAll(',', '.'));

    if (weight == null || weight <= 0 || dose == null || dose <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese valores válidos')),
      );
      return;
    }

    final provider = ref.read(insulinProvider.notifier);
    if (_isInverse) {
      provider.calculateCombinedTxInverse(weight: weight, totalDose: dose);
    } else {
      provider.calculateCombinedTx(weight: weight, dose: dose);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _clearInputsAndResult());
  }

  @override
  void dispose() {
    _weightController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(insulinProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tx Insulínica Combinada',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _InsulinInputField(
                  controller: _weightController,
                  label: 'Peso del Pte (kg)',
                  highlight: _isInverse,
                ),
                const SizedBox(height: 20),
                _InsulinInputField(
                  controller: _doseController,
                  label:
                      _isInverse ? 'U Total diaria' : 'Dosis (U/kg)',
                  highlight: _isInverse,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Modo inverso (U Total conocida)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  value: _isInverse,
                  onChanged: _toggleInverseMode,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calculate),
                    label: const Text(
                      'Calcular',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: _calculate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (result != null) InsulinResultCard(result: result),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InsulinInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool highlight;

  const _InsulinInputField({
    required this.controller,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = highlight ? colorScheme.primary : Colors.grey;

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
