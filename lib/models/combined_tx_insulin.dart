import 'package:insulinoterapia/models/insulin_result.dart';

class CombinedTxInsulin extends InsulinResult {
  final double morningNph;
  final double morningSimple;
  final double nightNph;
  final double nightSimple;
   double ? almuerzoSimple;

  CombinedTxInsulin({
    required double tdd,
    double ? morningDose,
    required double nightDose,
    required this.morningNph,
    required this.morningSimple,
    required this.nightNph,
    required this.nightSimple,
     this.almuerzoSimple,
    double? factor,
  }) : super(tdd: tdd, morningDose: morningDose, nightDose: nightDose, factor: factor);

  @override
  List<Map<String, String>> get doses {
    final list = <Map<String, String>>[
      {'label': 'U Total', 'value': '${tdd.toStringAsFixed(0)} U'},
      if (factor != null) {'label': 'Dosis U/kg', 'value': '${factor!.toStringAsFixed(1)} U/kg'},
      if (factor != null) {'label': 'AM (2/3)', 'value': '${morningDose!.toStringAsFixed(2)} U'},
      {'label': '  NPH AM', 'value': '${morningNph.toStringAsFixed(1)} U'},
      {'label': '  Simple AM', 'value': '${morningSimple.toStringAsFixed(1)} U'},
      if (nightDose != null) {'label': 'PM (1/3)', 'value': '${nightDose!.toStringAsFixed(1)} U'},
      if (almuerzoSimple != null)  {'label': '  Simple (Almuerzo)', 'value': '${almuerzoSimple!.toStringAsFixed(2)} U'},
     
      {'label': '  NPH PM', 'value': '${nightNph.toStringAsFixed(1)} U'},
      {'label': '  Simple PM', 'value': '${nightSimple.toStringAsFixed(1)} U'},
    ];
    return list;
  }
}