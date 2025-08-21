import 'package:flutter/material.dart';
import '../models/combined_tx_insulin.dart';

class CombinedTxInsulinCard extends StatelessWidget {
  final CombinedTxInsulin result;

  const CombinedTxInsulinCard({super.key, required this.result});

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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dose['label']!,
                    style: TextStyle(
                      fontWeight: dose['label']!.trim().startsWith('U Total') ? FontWeight.bold : FontWeight.normal,
                      fontSize: dose['label']!.trim().startsWith('U Total') ? 20 : 16,
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
          }).toList(),
        ),
      ),
    );
  }
}
