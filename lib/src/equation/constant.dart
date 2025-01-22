import 'package:equation/equation.dart';

class Constant extends Eq implements Value {
  final num value;

  const Constant(this.value);

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
  num toConstant() => value;

  @override
  (num, Eq) separateConstant() => (value, Constant(1));

  @override
  Eq factorOutMinus() => this;

  @override
  Eq distributeMinus() => value.isNegative ? Minus(Constant(-value)) : this;

  @override
  Eq dissolveMinus() => value.isNegative ? Minus(Constant(-value)) : this;

  @override
  Eq combineAddition() => this;

  @override
  Eq expandMultiplications({int? depth}) => this;

  @override
  Eq distributeExponent({int? depth}) => this;

  @override
  Eq simplifyDivisionOfAddition({int? depth}) => this;

  @override
  Eq combineMultiplications({int? depth}) => this;

  @override
  Eq combinePowers({int? depth}) => this;

  @override
  Eq factorOutAddition() => this;

  @override
  List<Eq> multiplicativeTerms() => [this];

  @override
  Eq? tryCancelDivision(Eq other) {
    assert(other.isSingle);
    if (other is Constant) {
      final res = value / other.value;
      if (!res.isInt) return null;
      return Constant(res);
    }
    return null;
  }

  @override
  bool get isSingle => true;

  @override
  Eq substitute(Map<String, Eq> substitutions) => this;

  @override
  bool hasVariable(Variable v) => false;

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) {
    final oc = other.simplify().toConstant();
    if (oc == null) return false;
    if (oc.isNaN || value.isNaN) return false;
    if (value == oc) return true;
    return (oc - value).abs() < epsilon;
  }

  @override
  String toString() => value.stringMaybeInt;

  @override
  Eq withConstant(num c) {
    num value = this.value * c;
    return value.isNegative ? Minus(Constant(-value)) : Constant(value);
  }

  @override
  bool get isLone => true;
}

const zero = Constant(0);

const one = Constant(1);

extension NumExt on num {
  bool get isInt {
    if(this is int) return true;
    if (isInfinite) return false;
    if (isNaN) return false;
    return (this - round()).abs() < 1e-8;
  }

  String get stringMaybeInt => isInt ? round().toString() : toString();
}
