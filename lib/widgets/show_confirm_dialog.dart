import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String message,
}) async {
  final screenWidth = MediaQuery.of(context).size.width;

  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Confirmación'),
            content: Text(
              message,
              style: TextStyle(fontSize: screenWidth < 400 ? 14 : 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withAlpha(179),
                ),
                child: const Text('Cancelar'),
              ),

              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      ) ??
      false;
}
