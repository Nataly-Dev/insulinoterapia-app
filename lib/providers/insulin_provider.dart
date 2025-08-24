import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/insulin_result.dart';
import '../models/combined_tx_insulin.dart';

final insulinProvider = StateNotifierProvider<InsulinNotifier, InsulinResult?>(
  (ref) => InsulinNotifier(),
);

class InsulinNotifier extends StateNotifier<InsulinResult?> {
  InsulinNotifier() : super(null);

  void clear() {
    state = null;
  }

  void calculateSingle({required double weight, required double dose}) {
    final tdd = weight * dose;
    //final nightDose = tdd * 0.33;

    state = InsulinResult(tdd: tdd);
  }

  void calculateInverseSingle({required double dose, required double weight}) {
    final factor = double.parse((dose / weight).toStringAsFixed(1));

    state = InsulinResult(tdd: dose, factor: factor);
  }

  ///////////////////////////////////////////////////////////////////////////////////////

  void calculateBidNph({required double weight, required double dose}) {
    final tdd = weight * dose;
    final morning = tdd * (2 / 3);
    final night = tdd * (1 / 3);
    state = InsulinResult(tdd: tdd, morningDose: morning, nightDose: night);
  }

  void calculateBidNphInverse({required double weight,required double totalDose,}) {
    final factor = (totalDose / weight);//double.parse((totalDose / weight).toStringAsFixed(1));

    final morning = totalDose * (2 / 3);
    final night = totalDose * (1 / 3);
    state = InsulinResult(
      tdd: totalDose,
      morningDose: morning,
      nightDose: night,
      factor: factor,
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  void calculateCombinedTx({required double weight, required double dose}) {
    final factor = dose;
    final tdd = weight * dose;

    // AM = 2/3, PM = 1/3
    final morningDose = tdd * (2 / 3);
    final nightDose = tdd * (1 / 3);

    // Dentro del desayuno: NPH 2/3, Simple 1/3
    final morningNph = morningDose * (2 / 3);
    final morningSimple = morningDose * (1 / 3);

    // Dentro de la cena: mitad y mitad
    final nightNph = nightDose * (1/2);
    final nightSimple = nightDose * (1/2);

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

    final dose = (totalDose / weight);
    final roundedDose = dose;

    calculateCombinedTx(weight: weight, dose: roundedDose);
  }

  ////////////////////////////////////////////////////////////////////////////////////

  void calcularTxCombinadaIntensificada({
    required double peso,
    required double dosis,
  }) {
    // Total Daily Dose
    final tdd = peso * dosis;

    // Distribución de dosis
    final morningDose = tdd * (2/3);
    final nightDose = tdd * (1/3);

    final morningNph = morningDose * (2/3);
    final morningSimple = morningDose * ((1/3) / 2);

    final lunchSimple = morningDose * ((1 / 3) / 2); // almuerzo simple

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
