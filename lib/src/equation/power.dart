import 'dart:math';

import 'package:equation/equation.dart';

class Power extends Eq {
  final Eq base;

  final Eq exponent;

  Power(this.base, this.exponent);

  factory Power.right(Eq base, Eq exponent) {
    if (base is Power) {
      return Power(base.base, Power.right(base.exponent, exponent));
    }
    return Power(base, exponent);
  }

  factory Power.left(Eq base, Eq exponent) => Power(base, exponent);

  @override
  (num, Eq) separateConstant() {
    {
      final c = toConstant();
      if (c != null) {
        return (c, Constant(1));
      }
    }
    final e = exponent.toConstant();
    if (e == null) return (1, this);
    if (base is! Times) return (1, this);
    final parts = base.multiplicativeTerms().expressions;
    num c = 1;
    final ret = <Eq>[];
    for (final part in parts) {
      final (cc, eq) = part.separateConstant();
      c *= cc;
      ret.add(eq);
    }
    if (ret.isEmpty) {
      return (c, Constant(1));
    }
    return (Constant(c).pow(Constant(e)).toConstant()!, Times(ret).pow(e));
    /*final terms = multiplicativeTerms();
    if (terms.expressions.length == 1 && terms.expressions.first is Power) {
      final c = terms.expressions.first.toConstant();
      if (c != null) {
        return (c, Constant(1));
      }
      return (1, terms.expressions.first);
    }
    num c = 1;
    List<Eq> eqs = [];
    for (final term in terms.expressions) {
      final cc = term.toConstant();
      if (cc != null) {
        c *= cc;
        continue;
      }
      final (ccc, m) = term.separateConstant();
      c *= ccc;
      if (!m.isSame(one)) {
        eqs.add(m);
      }
    }
    if (eqs.isEmpty) {
      return (c, Constant(1));
    }
    return (c, Times(eqs));*/
  }

  @override
  num? toConstant() {
    final ret = dissolveConstants();
    if (ret is Constant || ret is Minus) {
      return ret.toConstant();
    }
    return null;
  }

  @override
  Eq dissolveConstants({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final base = this.base.dissolveConstants(depth: depth);
    final exponent = this.exponent.dissolveConstants(depth: depth);
    final bc = base.toConstant();
    final ec = exponent.toConstant();
    if ((bc?.isNaN ?? false) || (ec?.isNaN ?? false)) return nan;
    if (ec != null && bc != null) {
      if (bc.isEqual(0) && ec.isEqual(0)) return nan;
      if (bc.isInfinite) {
        if (ec.isEqual(0)) return nan;
      }
      return Constant(pow(bc, ec)).dissolveMinus();
    }
    if (ec != null) {
      if (ec == 0) {
        return Constant(1.0);
      } else if (ec == 1) {
        return base;
      }
    }
    if (bc != null) {
      if (bc == 1) return Constant(1);
      if (bc == 0) return Constant(0);
    }
    return Power(base, exponent);
  }

  @override
  Eq factorOutMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Power(
      base.factorOutMinus(depth: depth),
      exponent.factorOutMinus(depth: depth),
    ).dissolveMinus(depth: 1);
  }

  @override
  Eq dissolveMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var base = this.base.dissolveMinus(depth: depth);
    var exponent = this.exponent.dissolveMinus(depth: depth);
    if (base is! Minus) {
      return Power(base, exponent);
    }
    final ec = exponent.toConstant()?.tryToInt;
    if (ec == null) return Power(base, exponent);
    // (-x)^(2n) = x^(2n)
    if (ec.isEven) {
      return Power(base.expression, exponent);
    }
    return Times([-one, Power(base.expression, exponent)]);
  }

  @override
  Eq distributeMinus() =>
      Power(base.distributeMinus(), exponent.distributeMinus());

  @override
  Eq dropMinus() => this;

  @override
  Eq shrink({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Power(base.shrink(depth: depth), exponent.shrink(depth: depth));
  }

  @override
  Eq combineAdditions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Power(
      base.combineAdditions(depth: depth),
      exponent.combineAdditions(depth: depth),
    );
  }

  @override
  Eq expandMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Power(
      base.expandMultiplications(depth: depth),
      exponent.expandMultiplications(depth: depth),
    );
  }

  @override
  Eq expandPowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var base = this.base.expandPowers(depth: depth);
    var exponent = this.exponent.expandPowers(depth: depth);
    if (base is! Plus) return Power(base, exponent);
    final ec = exponent.toConstant();
    if (ec == null || !ec.isInt) return Power(base, exponent);
    Eq ret = base;
    bool isDivision = ec.isNegative;
    for (int i = 1; i < ec.round().abs(); i++) {
      ret = (ret * base).expandMultiplications(depth: depth);
    }
    if (isDivision) return Power(ret, -one);
    return ret;
  }

  @override
  Eq distributeExponent({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var base = this.base
        .distributeExponent(depth: depth)
        .dissolveMinus(depth: 1);
    var exponent = this.exponent.distributeExponent(depth: depth);
    if (base is Minus) {
      base = base.expression;
      if (base is Times) {
        return Times([
          (-one).pow(exponent),
          ...base.expressions.map((e) {
            if (e is Power) return Power(e.base, Times([e.exponent, exponent]));
            return Power(e, exponent);
          }),
        ]);
      }
      if (base.isSame(one)) return Power(base, exponent);
      return Times([Power(-one, exponent), Power(base, exponent)]);
    }
    if (base is Times) {
      return Times(
        base.expressions.map((e) {
          if (e is Power) return Power(e.base, Times([e.exponent, exponent]));
          return Power(e, exponent);
        }),
      );
    }
    return Power(base, exponent);
  }

  @override
  Eq dissolvePowerOfPower({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var exponent = this.exponent.dissolvePowerOfPower(depth: depth);
    var base = this.base.dissolvePowerOfPower(depth: depth);
    if (base is Power) {
      return Power(base.base, Times([base.exponent, exponent]));
    } else if (base is Minus) {
      final inner = base.expression;
      if (inner is Power) {
        return Times([
          Power(-one, exponent) *
              Power(inner.base, Times([exponent, inner.exponent])),
        ]);
      }
    }
    return Power(base, exponent);
  }

  @override
  Eq expandDivision({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Power(
      base.expandDivision(depth: depth),
      exponent.expandDivision(depth: depth),
    );
  }

  @override
  Eq combineMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
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
      if (depth < 0) return this;
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
  Times multiplicativeTerms() {
    return Times(
      base.multiplicativeTerms().expressions.map((e) => Power(e, exponent)),
    );
  }

  @override
  (List<Eq> numerators, List<Eq> denominators) separateDivision() {
    final terms = multiplicativeTerms().expressions;
    final numerators = <Eq>[];
    final denominators = <Eq>[];
    for (final term in terms) {
      if (term is! Power) {
        numerators.add(term);
        continue;
      }
      final denom = term.toDenominator;
      if (denom == null) {
        numerators.add(term);
        continue;
      }
      denominators.add(denom);
    }
    return (numerators, denominators);
  }

  @override
  Eq? tryCancelDivision(Eq other) {
    other = other.simplify();
    Eq simplified = simplify();
    if (simplified.isSame(other)) return one;
    if (simplified is! Power) return simplified.tryCancelDivision(other);
    final list = simplified.multiplicativeTerms().expressions.toList();
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
    return simplified._tryCancelDivision(other);
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

  @override
  Eq reduceDivisions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Power(
      base.reduceDivisions(depth: depth),
      exponent.reduceDivisions(depth: depth),
    );
  }

  Eq? get toDenominator {
    if (base is Power) {
      final tmp = dissolvePowerOfPower();
      if (tmp is! Power) return null;
      return tmp.toDenominator;
    }
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
    otherSimplified = otherSimplified.simplify();
    if (thisSimplified is! Power) {
      return thisSimplified.isSame(otherSimplified, epsilon);
    }
    if (otherSimplified is! Power) {
      return false;
    }
    return thisSimplified.base.isSame(otherSimplified.base, epsilon) &&
        thisSimplified.exponent.isSame(otherSimplified.exponent, epsilon);
  }

  @override
  bool canDissolveConstants() {
    if (base.canDissolveConstants() || exponent.canDissolveConstants()) {
      return true;
    }
    final bc = base.toConstant();
    final ec = exponent.toConstant();
    if ((bc?.isNaN ?? false) || (ec?.isNaN ?? false)) return true;
    if (ec != null && bc != null) {
      return true;
    }
    if (ec != null) {
      if (ec == 0) {
        return true;
      } else if (ec == 1) {
        return true;
      }
    }
    if (bc != null) {
      if (bc == 1) return true;
      if (bc == 0) return true;
    }
    return false;
  }

  @override
  bool canDissolveMinus() {
    if (base.canDissolveMinus() || exponent.canDissolveMinus()) {
      return true;
    }
    if (base is! Minus) return false;
    final ec = exponent.toConstant();
    if (ec == null) return false;
    if (!ec.isInt) {
      return false;
    }
    return true;
  }

  @override
  bool canShrink() => base.canShrink() || exponent.canShrink();

  @override
  bool canCombineAdditions() =>
      base.canCombineAdditions() || exponent.canCombineAdditions();

  @override
  bool canFactorOutAddition() =>
      base.canFactorOutAddition() || exponent.canFactorOutAddition();

  @override
  bool canCombineMultiplications() =>
      base.canCombineMultiplications() || exponent.canCombineMultiplications();

  @override
  bool canExpandMultiplications() =>
      base.canExpandMultiplications() || exponent.canExpandMultiplications();

  @override
  bool canReduceDivisions() =>
      base.canReduceDivisions() || exponent.canReduceDivisions();

  @override
  bool canCombinePowers() =>
      base.canCombinePowers() || exponent.canCombinePowers();

  @override
  bool canExpandPowers() {
    if (this.base.canExpandPowers() || exponent.canExpandPowers()) {
      return true;
    }
    final ec = exponent.toConstant();
    if (ec == null || !ec.isInt || ec.round().isEqual(-1)) return false;
    var base = this.base.dissolveMinus(depth: 1);
    /*if (base is Minus) {
      base = base.expression;
    }*/
    if (base is! Plus || base.expressions.length < 2) return false;
    return true;
  }

  @override
  bool canDissolvePowerOfPower() {
    if (base.canDissolvePowerOfPower() || exponent.canDissolvePowerOfPower()) {
      return true;
    }
    if (base is Power) return true;
    return base is Minus && (base as Minus).expression is Power;
  }

  @override
  bool canDistributeExponent() {
    if (base.canDistributeExponent() || exponent.canDistributeExponent()) {
      return true;
    }
    var exp = base;
    if (exp is Minus) {
      return true;
    }
    return exp is Times;
  }

  @override
  Simplification? canSimplify() {
    Simplification? s = base.canSimplify() ?? exponent.canSimplify();
    if (s != null) return s;
    if (canDissolveConstants()) return Simplification.dissolveConstants;
    if (canDissolveMinus()) return Simplification.dissolveMinus;
    if (canDistributeExponent()) return Simplification.distributeExponent;
    if (canExpandPowers()) return Simplification.expandPowers;
    if (canDissolvePowerOfPower()) return Simplification.dissolvePowerOfPower;
    return null;
  }

  /*
  @override
  Eq simplify() {
    var base = this.base.simplify();
    var exponent = this.exponent.simplify();
    final ec = exponent.toConstant();
    final bc = base.toConstant();
    if ((bc?.isNaN ?? false) || (ec?.isNaN ?? false)) return nan;
    if (ec != null && bc != null) {
      if (bc.isEqual(0) && ec.isEqual(0)) return nan;
      if (bc.isInfinite) {
        if (ec.isEqual(0)) return nan;
      }
      return Constant(pow(bc, ec)).simplify();
    }
    if (ec != null) {
      if (ec == 0) {
        return Constant(1.0);
      } else if (ec == 1) {
        return base;
      }
    }
    if (bc != null) {
      if (bc == 1) return Constant(1);
      if (bc == 0) return Constant(0);
    }
    return Power(base, exponent).dissolvePowerOfPower();
  }*/

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) {
    final sb = StringBuffer();
    if (base.isLone && base is! Minus && base is! Power) {
      sb.write(base.toString(spec: spec));
    } else {
      sb.write(spec.lparen);
      sb.write(base.toString(spec: spec));
      sb.write(spec.rparen);
    }
    sb.write(spec.power);
    if (exponent.isLone) {
      sb.write(exponent.toString(spec: spec));
    } else {
      sb.write(spec.lparen);
      sb.write(exponent.toString(spec: spec));
      sb.write(spec.rparen);
    }
    return sb.toString();
  }

  static bool canCombinePower(Power a, Power b) {
    return a.exponent.isSame(b.exponent);
  }

  static Power? tryCombinePower(Power a, Power b) {
    // TODO dissolve powerOfPowers?
    if (!a.exponent.isSame(b.exponent)) return null;
    return Power(Times([a.base, b.base]), a.exponent);
  }
}
