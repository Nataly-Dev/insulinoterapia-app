import 'package:flutter/material.dart';
import '../models/insulin_result.dart';

class InsulinResultCard extends StatelessWidget {
  final InsulinResult result;

  const InsulinResultCard({super.key, required this.result});

  void clear() {

    // Aquí puedes implementar la lógica para limpiar el resultado

  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: result.doses.map((dose) {
            if (dose['label'] == 'TDD') {
              // Centrar solo la fila de TDD
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    '${dose['label']} : ${dose['value']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              );
            } else {
              //dosisi
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dose['label']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      dose['value']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }
          }).toList(),
        ),
      ),
    );
  }
}
