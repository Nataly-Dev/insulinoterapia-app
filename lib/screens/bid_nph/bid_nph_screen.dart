import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/insulin_provider.dart';
import '../../widgets/insulin_result_card.dart';

class BidNphScreen extends ConsumerStatefulWidget {
  const BidNphScreen({super.key});

  @override
  ConsumerState<BidNphScreen> createState() => _BidNphScreenState();
}

class _BidNphScreenState extends ConsumerState<BidNphScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  bool _isInverse = false;

  void _toggleInverseMode(bool value) {
    setState(() {
      _isInverse = value;
    });
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingrese valores válidos')));
      return;
    }

    if (_isInverse) {
      ref
          .read(insulinProvider.notifier)
          .calculateBidNphInverse(weight: weight, totalDose: dose);
    } else {
      ref
          .read(insulinProvider.notifier)
          .calculateBidNph(weight: weight, dose: dose);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _clearInputsAndResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(insulinProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'BID NPH',
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
                _buildInputField(
                  controller: _weightController,
                  label: 'Peso del Pte (kg)',
                  highlight: _isInverse,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _doseController,
                  label: _isInverse
                      ? 'Dosis total diaria (TDD)'
                      : 'Dosis (U/kg)',
                  highlight: _isInverse,
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text(
                    'Modo inverso (TDD conocida)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  value: _isInverse,
                  onChanged: _toggleInverseMode,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool highlight = false,
  }) {
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
