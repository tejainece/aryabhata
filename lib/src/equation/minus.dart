import 'package:equation/equation.dart';

class Minus extends Eq {
  final Eq expression;

  Minus(this.expression);

  @override
  num? toConstant() {
    final v = expression.simplify();
    if (v is! Constant) return null;
    return -v.value;
    /*
        final ec = expression.toConstant();
    if (ec == null) return null;
    return -ec;
     */
  }

  @override
  Eq dissolveConstants({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Minus(expression.dissolveConstants(depth: depth)).dissolveMinus();
  }

  @override
  (num, Eq) separateConstant() {
    final (c, ne) = expression.separateConstant();
    return (-c, ne);
  }

  @override
  Eq factorOutMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    int count = 1;
    var expression = this.expression.factorOutMinus(depth: depth);
    while (expression is Minus) {
      count++;
      expression = expression.expression;
    }
    return count % 2 == 0 ? expression : Minus(expression);
  }

  @override
  Eq dissolveMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    int count = 1;
    var expression = this.expression.dissolveMinus(depth: depth);
    while (expression is Minus) {
      count++;
      expression = expression.expression;
    }
    if (count.isEven) return expression;
    if (expression is Plus) {
      return Plus(
        expression.expressions.map((e) => Minus(e).dissolveMinus()).toList(),
      );
    }
    return Minus(expression);
  }

  @override
  Eq distributeMinus() {
    var eq = dissolveMinus();
    if (eq is! Minus) {
      return eq.distributeMinus();
    }
    eq = eq.expression;
    if (eq is Plus) {
      return Plus(
        eq.expressions.map((e) => Minus(e).distributeMinus()).toList(),
      );
    } else if (eq is Times) {
      bool isMinus = true;
      final ret = <Eq>[];
      for (var e in eq.expressions) {
        if (!isMinus) {
          ret.add(e);
          continue;
        }
        if (e is Plus) {
          ret.add(
            Plus(
              e.expressions.map((it) => Minus(it).distributeMinus()).toList(),
            ),
          );
          isMinus = false;
          continue;
        }
        ret.add(e);
      }
      if (isMinus) {
        return Minus(Times(ret));
      }
      return Times(ret);
    }
    return eq;
  }

  @override
  Eq dropMinus() {
    var ret = expression;
    while (ret is Minus) {
      ret = ret.expression;
    }
    return ret;
  }

  @override
  Eq shrink({int? depth}) => Minus(expression.shrink(depth: depth));

  @override
  Times multiplicativeTerms() {
    final e = dissolveConstants(depth: 1);
    if (e is Minus) {
      final inner = e.expression;
      if (inner.toConstant() != null) {
        return Times([Constant(-inner.toConstant()!)]);
      }
      return Times([-one, inner.multiplicativeTerms()]);
    }
    return e.multiplicativeTerms();
  }

  @override
  (List<Eq> numerators, List<Eq> denominators) separateDivision() {
    final (numerators, denominators) = expression.separateDivision();
    numerators.add(Eq.c(-1));
    return (numerators, denominators);
  }

  @override
  Eq combineAdditions({int? depth}) =>
      Minus(expression.combineAdditions(depth: depth));

  @override
  Eq expandMultiplications({int? depth}) =>
      Minus(expression.expandMultiplications(depth: depth));

  @override
  Eq expandPowers({int? depth}) => Minus(expression.expandPowers(depth: depth));

  @override
  Eq distributeExponent({int? depth}) =>
      Minus(expression.distributeExponent(depth: depth));

  @override
  Eq expandDivision({int? depth}) =>
      Minus(expression.expandDivision(depth: depth));

  @override
  Eq combineMultiplications({int? depth}) =>
      Minus(expression.combineMultiplications());

  @override
  Eq combinePowers({int? depth}) => Minus(expression.combinePowers());

  @override
  Eq dissolvePowerOfPower({int? depth}) =>
      Minus(expression.dissolvePowerOfPower());

  @override
  Eq factorOutAddition() =>
      Minus(expression.factorOutAddition()).dissolveMinus(depth: 1);

  @override
  Eq withConstant(num c) {
    var ret = expression.withConstant(c);
    return ret is Minus ? ret.expression : Minus(ret);
  }

  @override
  bool hasVariable(Variable v) => expression.hasVariable(v);

  @override
  Eq? tryCancelDivision(Eq other) {
    final ret = expression.tryCancelDivision(other);
    if (ret == null) return null;
    return Minus(ret);
  }

  @override
  Eq reduceDivisions({int? depth}) =>
      Minus(expression.reduceDivisions(depth: depth));

  @override
  bool get isSingle => false;

  @override
  bool get isLone => true; //expression.isLone;

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Minus(expression.substitute(substitutions));

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) {
    other = other.simplify();
    if (other is! Minus) {
      // TODO other is Plus
      // TODO exp is Plus
      return false;
    }
    return expression.isSame(other.expression, epsilon);
  }

  @override
  bool canDissolveConstants() => expression.canDissolveConstants();

  @override
  bool canDissolveMinus() {
    if (expression.canDissolveMinus()) return true;
    if (expression is Minus) return true;
    return expression is Plus;
  }

  @override
  bool canShrink() => expression.canShrink();

  @override
  bool canFactorOutAddition() => expression.canFactorOutAddition();

  @override
  bool canCombineAdditions() => expression.canCombineAdditions();

  @override
  bool canCombineMultiplications() => expression.canCombineMultiplications();

  @override
  bool canExpandMultiplications() => expression.canExpandMultiplications();

  @override
  bool canReduceDivisions() => expression.canReduceDivisions();

  @override
  bool canCombinePowers() => expression.canCombinePowers();

  @override
  bool canExpandPowers() => expression.canExpandPowers();

  @override
  bool canDissolvePowerOfPower() => expression.canDissolvePowerOfPower();

  @override
  bool canDistributeExponent() => expression.canDistributeExponent();

  @override
  Simplification? canSimplify() {
    final s = expression.canSimplify();
    if (s != null) return s;
    if (canDissolveMinus()) return Simplification.dissolveMinus;
    return null;
  }

  /*
  @override
  Eq simplify() {
    var inner = expression.simplify();
    if (inner is Minus) {
      return inner.expression;
    }
    return Minus(inner);
  }
   */

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) {
    final exp = expression;
    if (exp is Constant) {
      if (exp.value.isNegative) {
        return exp.toString(spec: spec);
      }
      return '-${exp.toString(spec: spec)}';
    } else if (exp.isLone) {
      return '-${exp.toString(spec: spec)}';
    }
    return '-(${expression.toString(spec: spec)})';
  }
}
