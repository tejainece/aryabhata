

import 'package:equation/equation.dart';

class Constant extends Eq implements Value {
  final double value;

  Constant(this.value);

  @override
  Eq simplify() {
    if (value.isNegative) {
      return Minus(Constant(-value));
    }
    return this;
  }

  @override
  bool isConstant() => true;

  @override
  double toConstant() => value;

  @override
  (double, Eq) separateConstant() => (value, Constant(1));

  @override
  Eq factorOutMinus() => this;

  @override
  Eq distributeMinus() => value.isNegative ? Minus(Constant(-value)) : this;

  @override
  Eq dissolveMinus() => value.isNegative ? Minus(Constant(-value)) : this;

  @override
  Eq combineAddition() => this;

  @override
  Eq expandMultiplications() => this;

  @override
  Eq distributeExponent() => this;

  @override
  Eq simplifyDivisionOfAddition() => this;

  @override
  Eq combineMultiplicationsAndPowers() => this;

  @override
  Eq factorOutAddition() => this;

  @override
  Eq substitute(Map<String, Eq> substitutions) => this;

  @override
  bool hasVariable(Variable v) => false;

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) =>
      other is Constant && (other.value - value).abs() < epsilon;

  @override
  String toString() => value.stringMaybeInt;

  @override
  Eq withConstant(double c) {
    double value = this.value * c;
    return value.isNegative ? Minus(Constant(-value)) : Constant(value);
  }

  @override
  bool get isLone => true;
}