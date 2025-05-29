// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
appBar: AppBar(
  title: const Text('Insulinoterapia'),

  centerTitle: true,

  elevation: 0, // opcional: más plano y moderno
),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
        fontWeight: FontWeight.w600, // Fuente más negrita
      );

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(15), // Reemplazo de withOpacity(0.05)
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


}
