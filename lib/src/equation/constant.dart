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
  (num, num)? toComplexConstant() => (1, 0);

  @override
  (num, Eq) separateConstant() => (value, Constant(1));

  @override
  Eq withConstant(num c) {
    num value = this.value * c;
    return value.isNegative ? Minus(Constant(-value)) : Constant(value);
  }

  @override
  (List<Eq> numerators, List<Eq> denominators) separateDivision() => (
    [this],
    [],
  );

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
  Eq dissolveImaginary() => this;

  @override
  Eq shrink({int? depth}) => this;

  @override
  Eq combineAdditions({int? depth}) => this;

  @override
  Eq expandMultiplications({int? depth}) => this;

  @override
  Eq expandDivision({int? depth}) => this;

  @override
  Eq combineMultiplications({int? depth}) => this;

  @override
  Eq combinePowers({int? depth}) => this;

  @override
  Eq expandPowers({int? depth}) => this;

  @override
  Eq dissolvePowerOfPower({int? depth}) => this;

  @override
  Eq dissolvePowerOfComplex({int? depth}) => this;

  @override
  Eq rationalizeComplexDenominator() => this;

  @override
  Eq distributeExponent({int? depth}) => this;

  @override
  Eq factorOutAddition() => this;

  @override
  Times multiplicativeTerms() => Times([this]);

  @override
  Eq reduceDivisions({int? depth}) => this;

  @override
  Eq? tryCancelDivision(Eq other) {
    other = other.simplify();
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
  bool needsParenthesis({bool noMinus = false}) {
    if (noMinus && isNegative) return true;
    return false;
  }

  @override
  bool get isNegative => value.isNegative;

  @override
  bool isSimpleConstant() => true;

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
  bool canShrink() => false;

  @override
  bool canDissolveConstants() => false;

  @override
  bool canDissolveMinus() => value.isNegative;

  @override
  bool canDissolveImaginary() => false;

  @override
  bool canCombineAdditions() => false;

  @override
  bool canFactorOutAddition() => false;

  @override
  bool canCombineMultiplications({int? depth}) => false;

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
  bool canDissolvePowerOfComplex() => false;

  @override
  bool canRationalizeComplexDenominator() => false;

  @override
  bool canDistributeExponent() => false;

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
    sb.write(value.abs().stringMaybeInt(maxPrecision: spec.maxPrecision));
    return sb.toString();
  }

  @override
  num toJson() => value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Constant && other.value.isEqual(value);
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
    return (this.abs() - abs().round()).abs() < 1e-8;
  }

  int? get tryToInt => isInt ? round() : null;

  String stringMaybeInt({int? maxPrecision}) {
    if (this is int || isInt) {
      return round().toString();
    } else if (isInfinite) {
      return '∞';
    } else if (isNaN) {
      return 'Nan';
    }
    String str = toString();
    if (maxPrecision == null) return str;
    if (!str.contains('.')) return str;
    final parts = str.split('.');
    if (parts[1].length <= maxPrecision) return str;
    return toStringAsFixed(maxPrecision);
  }

  bool isEqual(num other, [double epsilon = 1e-6]) {
    if (isNaN || other.isNaN) return false;
    if (isInfinite || other.isInfinite) return false;
    return (this - other).abs() < epsilon;
  }
}
