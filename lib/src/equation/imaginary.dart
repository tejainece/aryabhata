import 'package:equation/equation.dart';

class Imaginary extends Eq {
  const Imaginary._();

  @override
  Eq expandDivision({int? depth}) => this;

  @override
  Eq expandMultiplications({int? depth}) => this;

  @override
  (double, Eq) separateConstant() => (1, this);

  @override
  Eq dissolveConstants({int? depth}) => this;

  @override
  num? toConstant() => null;

  @override
  Eq factorOutMinus({int? depth}) => this;

  @override
  Eq dissolveMinus({int? depth}) => this;

  @override
  Eq dropMinus() => this;

  @override
  Eq distributeMinus() => this;

  @override
  Eq combineMultiplications({int? depth}) => this;

  @override
  Eq combinePowers({int? depth}) => this;

  @override
  Eq expandPowers({int? depth}) => this;

  @override
  Times multiplicativeTerms() => Times([this]);

  @override
  Eq factorOutAddition() => this;

  @override
  Eq combineAddition() => this;

  @override
  Eq distributeExponent({int? depth}) => this;

  @override
  Eq dissolvePowerOfPower({int? depth}) => this;

  @override
  Eq reduceDivisions({int? depth}) => this;

  @override
  Eq? tryCancelDivision(Eq other) => other is Imaginary ? one : null;

  @override
  bool get isLone => true;

  @override
  bool get isSingle => true;

  @override
  bool hasVariable(Variable v) => false;

  @override
  Eq substitute(Map<String, Eq> substitutions) => substitutions['i'] ?? this;

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) => other is Imaginary;

  @override
  bool canDissolveConstants() => false;

  @override
  bool canDissolveMinus() => false;

  @override
  bool canFactorOutAddition() => false;

  @override
  bool canCombineMultiplications() => false;

  @override
  bool canExpandMultiplications() => false;

  @override
  bool canReduceDivisions() => false;

  @override
  bool canCombinePowers() => false;

  @override
  bool canExpandPowers() => false;

  @override
  bool canDissolvePowerOfPower() => false;

  @override
  bool canDistributeExponent() => false;

  @override
  Simplification? canSimplify() => null;

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) => 'i';
}

const i = Imaginary._();
