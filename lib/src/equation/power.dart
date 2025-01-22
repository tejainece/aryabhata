import 'dart:math';

import 'package:equation/equation.dart';

class Power extends Eq {
  final Eq base;

  final Eq exponent;

  Power(this.base, this.exponent);

  factory Power.right(Eq base, Eq exponent) {
    // TODO handle minus(power)
    if (base is Power) {
      return Power(base.base, Power(base.exponent, exponent));
    }
    return Power(base, exponent);
  }

  factory Power.left(Eq base, Eq exponent) => Power(base, exponent);

  @override
  Eq simplify() {
    var base = this.base.simplify();
    var exponent = this.exponent.simplify();
    final ec = exponent.toConstant();
    final bc = base.toConstant();
    if (ec != null && bc != null) {
      return Constant(
        pow(base.toConstant()!, exponent.toConstant()!).toDouble(),
      ).simplify();
    }
    if (ec != null) {
      if (ec == 0) {
        return Constant(1.0);
      } else if (ec == 1) {
        return base;
      }
    }
    if (bc != null) {
      if (bc == 1) {
        return Constant(1);
      }
    }

    return Power(base, exponent);
  }

  @override
  (double, Eq) separateConstant() => (1, this);

  // TODO improve
  @override
  Eq factorOutMinus() =>
      Power(base.factorOutMinus(), exponent.factorOutMinus());

  // TODO improve
  @override
  Eq dissolveMinus() => Power(base.dissolveMinus(), exponent.dissolveMinus());

  // TODO improve
  @override
  Eq distributeMinus() =>
      Power(base.distributeMinus(), exponent.distributeMinus());

  // TODO improve
  @override
  Eq combineAddition() =>
      Power(base.combineAddition(), exponent.combineAddition());

  @override
  Eq expandMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }

    var base = this.base.expandMultiplications(depth: depth);
    if (exponent.simplify().isConstant()) {
      final c = exponent.simplify().toConstant()!;
      if (!c.isInt) {
        return Power(base, Constant(c).dissolveMinus());
      }
      Eq ret = base;
      for (int i = 1; i < c; i++) {
        ret = (ret * base).expandMultiplications(depth: depth);
      }
      return ret;
    }
    return Power(base, exponent.expandMultiplications(depth: depth));
  }

  @override
  Eq distributeExponent({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }
    var base = this.base.distributeExponent(depth: depth);
    var exponent = this.exponent.distributeExponent(depth: depth);
    // TODO handle unary minus
    if (base is Times) {
      return Times(base.expressions.map((e) => Power(e, exponent)));
    }
    return Power(base, exponent);
  }

  @override
  Eq simplifyDivisionOfAddition({int? depth}) {
    // TODO Power(expressions.map((e) => e.simplifyDivisionOfAddition()).toList());
    throw UnimplementedError();
  }

  @override
  Eq combineMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }
    return Power(
      base.combineMultiplications(depth: depth),
      exponent.combineMultiplications(depth: depth),
    );
  }

  @override
  Eq combinePowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }
    return Power(
      base.combinePowers(depth: depth),
      exponent.combinePowers(depth: depth),
    );
  }

  @override
  Eq factorOutAddition() =>
      Power(base.factorOutAddition(), exponent.factorOutAddition());

  @override
  List<Eq> multiplicativeTerms() => [this];

  @override
  Eq? tryCancelDivision(Eq other) {
    if (simplify().isSame(other.simplify())) return one;
    assert(other.isSingle);
    final list = splitPower().cast<Eq>();
    if (list.length > 1) {
      for (int i = 0; i < list.length; i++) {
        final v = list[i];
        final d = v.tryCancelDivision(other);
        if (d == null) continue;
        if (!d.isSame(one)) {
          list[i] = d;
        } else {
          list.removeAt(i);
        }
        return Times(
          list,
        ).combineMultiplications(depth: 1).combinePowers(depth: 1);
      }
    }
    return _tryCancelDivision(other);
  }

  Eq? _tryCancelDivision(Eq other) {
    if (other is Power) {
      if (!base.isSame(other.base)) return null;
      if (exponent.isSame(other.exponent)) return one;
      return Power(base, exponent - other.exponent);
    }
    if (!base.isSame(other)) return null;
    if (exponent.isSame(one)) return one;
    return Power(base, exponent - one);
  }

  List<Power> splitPower() {
    final base = this.base;
    if (base is Times) {
      return base.expressions.map((e) => Power(e, exponent)).toList();
    } else if (base is Minus) {
      final exp = base.expression;
      if (exp is Times) {
        return [
          Power(Minus(exp.expressions.first), exponent),
          ...exp.expressions.skip(1).map((e) => Power(e, exponent)),
        ];
      }
    }
    return [this];
  }

  Eq? get toDenominator {
    final eq = exponent.dissolveMinus();
    if (eq is! Minus) {
      return null;
    }
    if (eq.expression.toConstant() == 1) {
      return base;
    }
    return Power(base, eq.expression);
  }

  @override
  bool get isLone => true;

  @override
  bool get isSingle => base.isSingle;

  @override
  bool hasVariable(Variable v) =>
      base.hasVariable(v) || exponent.hasVariable(v);

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Power(base.substitute(substitutions), exponent.substitute(substitutions));

  @override
  bool isSame(Eq otherSimplified, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    final other = otherSimplified.simplify();
    if (thisSimplified is! Power) {
      return thisSimplified.isSame(other, epsilon);
    }
    otherSimplified = otherSimplified.simplify();
    if (otherSimplified is! Power) {
      return false;
    }
    return thisSimplified.base.isSame(otherSimplified.base, epsilon) &&
        thisSimplified.exponent.isSame(otherSimplified.exponent, epsilon);
  }

  @override
  String toString() {
    final sb = StringBuffer();
    if (base.isLone && base is! Minus) {
      sb.write(base);
    } else {
      sb.write('(');
      sb.write(base);
      sb.write(')');
    }
    sb.write('^');
    if (exponent.isLone) {
      sb.write(exponent);
    } else {
      sb.write('(');
      sb.write(exponent);
      sb.write(')');
    }
    return sb.toString();
  }
}
