import 'package:equation/equation.dart';

class Imaginary extends Eq {
  const Imaginary._();

  @override
  Eq simplifyDivisionOfAddition() => this;

  @override
  Eq expandMultiplications() => this;

  @override
  bool isSame(Eq other, [double epsilon = 0.000001]) => other is Imaginary;

  @override
  Eq simplify() => this;

  @override
  Eq distributeExponent() => this;

  @override
  Eq combineMultiplicationsAndPowers() => this;

  @override
  Eq factorOutAddition() => this;

  @override
  Eq substitute(Map<String, Eq> substitutions) {
    return substitutions['i'] ?? this;
  }

  @override
  Eq combineAddition() => this;

  @override
  Eq factorOutMinus() => this;

  @override
  Eq dissolveMinus() => this;

  @override
  Eq distributeMinus() => this;

  @override
  bool get isLone => true;
}

const i = Imaginary._();
