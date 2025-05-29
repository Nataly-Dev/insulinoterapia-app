import 'package:insulinoterapia/screens/bid_nph/bid_nph_screen.dart';
import 'package:insulinoterapia/widgets/insulin_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/insulin_provider.dart';
import '../../widgets/show_confirm_dialog.dart';

class SingleDosePmScreen extends ConsumerStatefulWidget {
  const SingleDosePmScreen({super.key});

  @override
  ConsumerState<SingleDosePmScreen> createState() => _SingleDosePmScreenState();
}

class _SingleDosePmScreenState extends ConsumerState<SingleDosePmScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  bool _inverseMode = false;
  void _clearInputsAndResult() {
    _weightController.clear();
    _doseController.clear();
    ref.read(insulinProvider.notifier).clear();
  }
  void _toggleInverseMode(bool value) {
    setState(() {
      _inverseMode = value;
    });
    _clearInputsAndResult();
  }
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _clearInputsAndResult();
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _doseController.dispose();

    super.dispose();
  }

void _onCalculate() async {
  final weight = double.tryParse(_weightController.text.trim());
  final dose = double.tryParse(_doseController.text.trim());

  if (weight == null || weight <= 0) {
    _showError('Por favor ingrese un peso válido y positivo.');
    return;
  }

  if (dose == null || dose <= 0) {
    _showError('Por favor ingrese una dosis válida y positiva.');
    return;
  }

  final bool shouldShowWarning = _inverseMode ? dose > 40 : dose > 0.6;

  if (shouldShowWarning) {
    final continuar = await showConfirmationDialog(
      context: context,
      message: _inverseMode
          ? 'La dosis no puede sobrepasar 40 U en total.\n\n¿Desea continuar al esquema BID NPH?'
          : 'La dosis no puede sobrepasar 0.6 U/kg.\n\n¿Desea continuar al esquema BID NPH?',
    );

    if (continuar) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BidNphScreen()),
      );
    }

    return; // Importante: detener el flujo si se muestra la advertencia
  }

  // Ejecutar el cálculo correspondiente
  final insulinNotifier = ref.read(insulinProvider.notifier);
  _inverseMode
      ? insulinNotifier.calculateInverseSingle(dose: dose, weight: weight)
      : insulinNotifier.calculateSingle(weight: weight, dose: dose);
}


  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(insulinProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dosis única PM',
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
                _buildInputField(
                  context,
                  controller: _weightController,
                  label: 'Peso Pte (kg)',
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  context,
                  controller: _doseController,
                  label: _inverseMode ? 'Dosis TDD' : 'Dosis (U/kg)',
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Modo inverso (TDD conocida)',style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,),
                  ),
                  value: _inverseMode,
                  onChanged: _toggleInverseMode,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calcular'),
                    onPressed: _onCalculate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),                    ),
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

  Widget _buildInputField(
    BuildContext context, {
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
