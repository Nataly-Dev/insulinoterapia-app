import 'package:insulinoterapia/widgets/insulin_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/insulin_provider.dart';

class CombinedTxItensifiedScreen extends ConsumerStatefulWidget {
  const CombinedTxItensifiedScreen({super.key});

  @override
  ConsumerState<CombinedTxItensifiedScreen> createState() => _CombinedTxIntensifiesScreenState();
}

class _CombinedTxIntensifiesScreenState extends ConsumerState<CombinedTxItensifiedScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(insulinProvider.notifier).clear();
    });
  }

  void _onCalculate() {
    final weight = double.tryParse(_weightController.text.trim());
    final dose = double.tryParse(_doseController.text.trim());

    if (weight == null || weight <= 0 || dose == null || dose <= 0) {
      _showError('Ingrese valores válidos');
      return;
    }

    ref.read(insulinProvider.notifier).calcularTxCombinadaIntensificada(peso: weight, dosis: dose);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final combinedTx = ref.watch(insulinProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tx Intensificada',
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
                _buildInputField(controller: _weightController, label: 'Peso del Pte (kg)'),
                const SizedBox(height: 16),
                _buildInputField(controller: _doseController, label: 'Dosis (U/kg)'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calculate),
                    label: const Text(
                      'Calcular',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: _onCalculate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (combinedTx != null) InsulinResultCard(result: combinedTx),
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
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
         labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),      
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
