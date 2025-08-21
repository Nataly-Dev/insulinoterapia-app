import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon/icon.png',
          height: isTablet ? 115 : 100,
          fit: BoxFit.contain,
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Información',
            onPressed: () => _mostrarAyuda(context, isTablet),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMenuItem(
                  context,
                  label: 'Dosis Única PM',
                  icon: Icons.medical_information,
                  onTap: () => context.push('/singleDosePm'),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  context,
                  label: 'BID NPH',
                  icon: Icons.local_hospital,
                  onTap: () => context.push('/bidNph'),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  context,
                  label: 'Tx Insulínica Combinada',
                  icon: Icons.medication,
                  onTap: () => context.push('/combinedTx'),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  context,
                  label: 'Tx Combinada Intensificada',
                  icon: Icons.bloodtype,
                  onTap: () => context.push('/txIntensified'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: textStyle)),
            Icon(Icons.chevron_right, color: colorScheme.onSurface),
          ],
        ),
      ),
    );
  }

void _mostrarAyuda(BuildContext context, bool isTablet) {
  final colorScheme = Theme.of(context).colorScheme;
  final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontWeight: FontWeight.w600,
  );

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Información general'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Esta aplicación está diseñada para apoyar al personal médico en el cálculo de dosificación de insulina subcutánea en pacientes diabéticos.',
            ),
            SizedBox(height: 12),
            Text(
              '📋 ¿Cómo usarla?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              '1. Selecciona el esquema de tratamiento deseado.\n'
              '2. Ingresa el peso del paciente en kilogramos.\n'
              '3. Ajusta la dosis (u/kg) según criterio médico.\n'
              '4. Revisa la dosis total sugerida.',
            ),
            SizedBox(height: 12),
            Text(
              '💉 Esquemas disponibles:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              '- Dosis Única PM\n'
              '- BID NPH\n'
              '- Tratamiento Insulínico Combinado\n'
              '- Tratamiento Combinado Intensificado',
            ),
            SizedBox(height: 12),
            Text(
              '⚠️ Importante:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Esta herramienta es de apoyo clínico y no sustituye la evaluación médica individualizada.\nEl cálculo final debe ser validado por el profesional tratante.',
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Aceptar', style: textStyle),
          ),
        ),
      ],
    ),
  );
}


}
