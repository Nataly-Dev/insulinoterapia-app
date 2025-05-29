import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/insulin_result.dart';
import '../models/combined_tx_insulin.dart';

final insulinProvider = StateNotifierProvider<InsulinNotifier, InsulinResult?>(
  (ref) => InsulinNotifier(),
);

class InsulinNotifier extends StateNotifier<InsulinResult?> {
  InsulinNotifier() : super(null);

  void clear() {state = null;}

    void calculateSingle({required double weight, required double dose}) {
    final tdd = weight * dose;
    final nightDose = tdd * 0.33;

    state = InsulinResult(
      tdd: tdd,
      nightDose: nightDose,
    );
  }

  void calculateInverseSingle({required double dose, required double weight}) {
    final factor = dose / weight;
    state = InsulinResult(
      tdd: dose,
      nightDose: dose * 0.33,
      factor: factor,
    );
  }
  ///////////////////////////////////////////////////////////////////////////////////////

  void calculateBidNph({required double weight, required double dose}) {
    final tdd = weight * dose;
    final morning = tdd * 0.66;
    final night = tdd * 0.33;
    state = InsulinResult(
      tdd: tdd,
      morningDose: morning,
      nightDose: night,
    );
  }

  void calculateBidNphInverse({required double weight, required double totalDose}) {
    final factor = totalDose / weight;
    final morning = totalDose * 0.66;
    final night = totalDose * 0.33;
    state = InsulinResult(
      tdd: totalDose,
      morningDose: morning,
      nightDose: night,
      factor: factor,
    );
  }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////
  void calculateCombinedTx({
    required double weight,
    required double dose,
  }) {
    final factor = dose;
    final tdd = weight * dose;
    final morningDose = tdd * 0.66;
    final nightDose = tdd * 0.33;

    // Aquí se crea el modelo extendido con dosis NPH y Simple
    final morningNph = morningDose * 0.66;  // ej: 2/3
    final morningSimple = morningDose * 0.33; // ej: 1/3

    final nightNph = nightDose * 0.5;
    final nightSimple = nightDose * 0.5;

    state = CombinedTxInsulin(
      factor: factor,
      tdd: tdd,
      morningDose: morningDose,
      nightDose: nightDose,
      morningNph: morningNph,
      morningSimple: morningSimple,
      nightNph: nightNph,
      nightSimple: nightSimple,
    );
  }

  void calculateCombinedTxInverse({required double weight,required double totalDose,}) {
    // Ejemplo modo inverso, ajusta según necesidad
    final dose = (totalDose / weight);
    calculateCombinedTx(weight: weight, dose: dose);
  }

  ////////////////////////////////////////////////////////////////////////////////////


  void calcularTxCombinadaIntensificada({
    required double peso,
    required double dosis,
  }) {
    // Total Daily Dose
    final tdd = peso * dosis;

    // Distribución de dosis
    final morningDose = tdd * 0.66;
    final nightDose = tdd * 0.33;

    final morningNph = morningDose *0.66;
    final morningSimple = morningDose *(0.33/2); 	

    final lunchSimple = morningDose * (0.33 /2); // Ejemplo de almuerzo simple

    final nightNph = nightDose * 0.5;
    final nightSimple = nightDose * 0.5;

    state = CombinedTxInsulin(
      tdd: tdd,
      morningDose: morningDose,
      nightDose: nightDose,
      morningNph: morningNph,
      morningSimple: morningSimple,
      almuerzoSimple: lunchSimple,
      nightNph: nightNph,
      nightSimple: nightSimple,
      factor: dosis,
    );
  }


  
}

