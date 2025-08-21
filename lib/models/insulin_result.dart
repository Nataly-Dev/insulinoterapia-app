class InsulinResult {
  final double tdd;
  final double ? morningDose;
  final double ? nightDose;
  final double? factor; // solo se usa en modo inverso

  InsulinResult({
    required this.tdd,
    this.morningDose,
    this.nightDose,
    this.factor,
  });

  List<Map<String, String>> get doses {
    final list = <Map<String, String>>[
       {'label': 'U Total', 'value': '${tdd.toStringAsFixed(0)} U'},
      if (factor != null)
        {'label': 'Dosis U/kg', 'value': '${factor!.toStringAsFixed(1)} U/kg'},
      if (morningDose != null)
        {'label': 'AM (2/3)', 'value': '${morningDose!.toStringAsFixed(1)} U'},
      if (nightDose != null)
        {'label': 'PM (1/3)', 'value': '${nightDose!.toStringAsFixed(1)} U'},
    ];
    return list;
  }

}