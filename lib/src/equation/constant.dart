import 'package:equation/equation.dart';

class Constant extends Eq {
  final num value;

  const Constant(this.value);

  @override
  Eq dissolveConstants({int? depth}) => this;

  @override
  bool isConstant() => true;

  @override
  num toConstant() => value;

  @override
  (num, Eq) separateConstant() => (value, Constant(1));

  @override
  Eq withConstant(num c) {
    num value = this.value * c;
    return value.isNegative ? Minus(Constant(-value)) : Constant(value);
  }

  @override
  Eq factorOutMinus({int? depth}) => this;

  @override
  Eq distributeMinus() => value.isNegative ? Minus(Constant(-value)) : this;

  @override
  Eq dissolveMinus({int? depth}) =>
      value.isNegative ? Minus(Constant(-value)) : this;

  @override
  Eq dropMinus() => this;

  @override
  Eq combineAddition() => this;

  @override
  Eq expandMultiplications({int? depth}) => this;

  @override
  Eq distributeExponent({int? depth}) => this;

  @override
  Eq expandDivision({int? depth}) => this;

  @override
  Eq combineMultiplications({int? depth}) => this;

  @override
  Eq combinePowers({int? depth}) => this;

  @override
  Eq dissolvePowerOfPower({int? depth}) => this;

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
  bool get isLone => true;

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
  bool canDissolveConstants() => false;

  @override
  bool canDissolveMinus() => value.isNegative;

  @override
  bool canCombinePowers() => false;

  @override
  bool canDissolvePowerOfPower() => false;

  @override
  Simplification? canSimplify() => null;

  /*
  @override
  Eq simplify() {
    if (value.isNegative) {
      return Minus(Constant(-value));
    }
    return this;
  }*/

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) {
    final sb = StringBuffer();
    if (value.isNegative) {
      sb.write(spec.minus);
    }
    sb.write(value.abs().stringMaybeInt);
    return sb.toString();
  }
}

const zero = Constant(0);

const one = Constant(1);

const two = Constant(2);

const three = Constant(3);

const ten = Constant(10);

const nan = Constant(double.nan);

const infinity = Constant(double.infinity);

extension NumExt on num {
  bool get isInt {
    if (this is int) return true;
    if (isInfinite) return false;
    if (isNaN) return false;
    return (this - round()).abs() < 1e-8;
  }

  int? get tryToInt => isInt ? round() : null;

  String get stringMaybeInt => isInt ? round().toString() : toString();

  bool isEqual(num other, [double epsilon = 1e-6]) {
    if (isNaN || other.isNaN) return false;
    if (isInfinite || other.isInfinite) return false;
    return (this - other).abs() < epsilon;
  }
}
