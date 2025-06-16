import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String message,
}) async {
  final screenWidth = MediaQuery.of(context).size.width;
  final colorScheme = Theme.of(context).colorScheme;

  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirmación',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 2,
                  width: double.infinity,
                  color: colorScheme.primary,
                ),
              ],
            ),
            content: Text(
              message,
              style: TextStyle(fontSize: screenWidth < 400 ? 14 : 16),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              // Botón Cancelar con fondo gris
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Cancelar'),
              ),

              // Botón Aceptar con fondo primario
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      ) ??
      false;
}
