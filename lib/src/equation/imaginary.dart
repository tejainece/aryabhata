import 'package:equation/equation.dart';

class Imaginary extends Eq {
  const Imaginary._();

  @override
  Eq simplifyDivisionOfAddition({int? depth}) => this;

  @override
  Eq expandMultiplications({int? depth}) => this;

  @override
  Eq simplify() => this;

  @override
  Eq distributeExponent({int? depth}) => this;

  @override
  Eq combineMultiplications({int? depth}) => this;

  @override
  Eq combinePowers({int? depth}) => this;

  @override
  List<Eq> multiplicativeTerms() => [this];

  @override
  Eq factorOutAddition() => this;

  @override
  Eq combineAddition() => this;

  @override
  Eq factorOutMinus() => this;

  @override
  Eq dissolveMinus() => this;

  @override
  Eq distributeMinus() => this;

  @override
  (double, Eq) separateConstant() => (1, this);

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
  String toString() => 'i';
}

const i = Imaginary._();
