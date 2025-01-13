import 'package:equation/equation.dart';

class Imaginary extends Eq {
  const Imaginary._();

  @override
  Eq expandDivisions() => this;

  @override
  Eq expandMultiplications() => this;

  @override
  bool isSame(Eq other, [double epsilon = 0.000001]) => other is Imaginary;

  @override
  Eq simplify() => this;

  @override
  Eq simplifyPowers() => this;

  @override
  Eq simplifyMultiplications() => this;

  @override
  Eq substitute(Map<String, Eq> substitutions) {
    return substitutions['i'] ?? this;
  }
}

const i = Imaginary._();