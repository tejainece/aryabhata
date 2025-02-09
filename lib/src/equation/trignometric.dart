import 'dart:math';

import 'package:equation/equation.dart';

// TODO implement log

// TODO implement angle simplification

abstract class Trig extends Eq {
  Eq get expression;

  @override
  (double, Eq) separateConstant() => (1, this);

  @override
  Eq dropMinus() => this;

  @override
  Times multiplicativeTerms() => Times([this]);

  @override
  bool get isLone => true;

  @override
  bool get isSingle => true;

  @override
  Eq? tryCancelDivision(Eq other) => isSame(other) ? Constant(1.0) : null;

  @override
  bool canShrink() => expression.canShrink();

  @override
  bool canDissolveConstants() {
    if (expression.canDissolveConstants()) return true;
    return expression.toConstant() != null;
  }

  @override
  bool canDissolveMinus() {
    if (expression.canDissolveMinus()) return true;
    return expression is Minus;
  }

  @override
  bool canCombineAdditions() => expression.canCombineAdditions();

  @override
  bool canFactorOutAddition() => expression.canFactorOutAddition();

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
    final ret = expression.canSimplify();
    if (ret != null) return ret;
    if (canDissolveConstants()) return Simplification.dissolveConstants;
    if (canDissolveMinus()) return Simplification.dissolveMinus;
    return null;
  }
}

class Cos extends Trig {
  @override
  final Eq expression;

  Cos(this.expression);

  @override
  double? toConstant() {
    final c = expression.simplify().toConstant();
    if (c == null) return null;
    return cos(c);
  }

  @override
  Eq dissolveConstants({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final exp = expression.dissolveConstants(depth: depth);
    final c = exp.toConstant();
    if (c != null) {
      return Constant(cos(c)).dissolveMinus();
    }
    return Cos(exp);
  }

  @override
  Eq factorOutMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var inner = expression.factorOutMinus(depth: depth);
    if (inner is Minus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }

  @override
  Eq dissolveMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var inner = expression.dissolveMinus(depth: depth);
    if (inner is Minus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }

  @override
  Eq shrink({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.shrink(depth: depth));
  }

  @override
  Eq distributeMinus() {
    var inner = expression.distributeMinus();
    if (inner is Minus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }

  @override
  Eq combineAdditions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.combineAdditions());
  }

  @override
  Eq expandMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.expandMultiplications(depth: depth));
  }

  @override
  Eq expandPowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.expandPowers(depth: depth));
  }

  @override
  Eq distributeExponent({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.distributeExponent(depth: depth));
  }

  @override
  Eq dissolvePowerOfPower({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.dissolvePowerOfPower(depth: depth));
  }

  @override
  Eq expandDivision({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.expandDivision(depth: depth));
  }

  @override
  Eq reduceDivisions({int? depth}) =>
      Cos(expression.reduceDivisions(depth: depth));

  @override
  Eq combineMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.combineMultiplications(depth: depth));
  }

  @override
  Eq combinePowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Cos(expression.combinePowers(depth: depth));
  }

  @override
  Eq factorOutAddition() => Cos(expression.factorOutAddition());

  @override
  bool hasVariable(Variable v) => expression.hasVariable(v);

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Cos(expression.substitute(substitutions));

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    if (thisSimplified is! Cos) {
      return thisSimplified.isSame(other, epsilon);
    }
    other = other.simplify();
    if (other is! Cos) {
      return false;
    }
    return thisSimplified.expression.isSame(other.expression, epsilon);
  }

  /*
  @override
  Eq simplify() {
    var inner = expression.simplify();
    var c = inner.toConstant();
    if (c != null) {
      return Constant(cos(c));
    } else if (inner is Minus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }
   */

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) =>
      'cos(${expression.toString(spec: spec)})';
}

class Sin extends Trig {
  @override
  final Eq expression;

  Sin(this.expression);

  @override
  double? toConstant() {
    final c = expression.simplify().toConstant();
    if (c == null) return null;
    return sin(c);
  }

  @override
  Eq dissolveConstants({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final exp = expression.dissolveConstants(depth: depth);
    final c = exp.toConstant();
    if (c != null) {
      return Constant(sin(c)).dissolveMinus();
    }
    return Sin(exp);
  }

  @override
  Eq combineAdditions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.combineAdditions());
  }

  @override
  Eq factorOutMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var inner = expression.factorOutMinus(depth: depth);
    if (inner is Minus) {
      return Minus(Sin(inner.expression));
    }
    return Sin(inner);
  }

  @override
  Eq dissolveMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var inner = expression.dissolveMinus(depth: depth);
    if (inner is Minus) {
      return Minus(Sin(inner.expression));
    }
    return Sin(inner);
  }

  @override
  Eq distributeMinus() {
    var inner = expression.distributeMinus();
    if (inner is Minus) {
      return Minus(Sin(inner.expression));
    }
    return Sin(inner);
  }

  @override
  Eq shrink({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.shrink(depth: depth));
  }

  @override
  Eq expandMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.expandMultiplications(depth: depth));
  }

  @override
  Eq expandPowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.expandPowers(depth: depth));
  }

  @override
  Eq combinePowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.combinePowers(depth: depth));
  }

  @override
  Eq dissolvePowerOfPower({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.dissolvePowerOfPower(depth: depth));
  }

  @override
  Eq distributeExponent({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.distributeExponent(depth: depth));
  }

  @override
  Eq expandDivision({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.expandDivision(depth: depth));
  }

  @override
  Eq reduceDivisions({int? depth}) =>
      Sin(expression.reduceDivisions(depth: depth));

  @override
  Eq combineMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Sin(expression.combineMultiplications(depth: depth));
  }

  @override
  Eq factorOutAddition() => Sin(expression.factorOutAddition());

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Sin(expression.substitute(substitutions));

  @override
  bool hasVariable(Variable v) => expression.hasVariable(v);

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    if (thisSimplified is! Sin) {
      return thisSimplified.isSame(other, epsilon);
    }
    other = other.simplify();
    if (other is! Sin) {
      return false;
    }
    return thisSimplified.expression.isSame(other.expression, epsilon);
  }

  /*
  @override
  Eq simplify() {
    var inner = expression.simplify();
    final c = inner.toConstant();
    if (c != null) {
      return Constant(sin(c));
    } else if (inner is Minus) {
      return Minus(Sin(inner.expression));
    }
    return Sin(inner);
  }
   */

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) =>
      'sin(${expression.toString(spec: spec)})';
}

class Tan extends Trig {
  @override
  final Eq expression;

  Tan(this.expression);

  @override
  double? toConstant() {
    final c = expression.simplify().toConstant();
    if (c == null) return null;
    return tan(c);
  }

  @override
  Eq dissolveConstants({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final exp = expression.dissolveConstants(depth: depth);
    final c = exp.toConstant();
    if (c != null) {
      return Constant(tan(c)).dissolveMinus();
    }
    return Tan(exp);
  }

  @override
  Eq combineAdditions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.combineAdditions());
  }

  @override
  Eq factorOutMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var inner = expression.factorOutMinus(depth: depth);
    if (inner is Minus) {
      return Minus(Tan(inner.expression));
    }
    return Tan(inner);
  }

  @override
  Eq dissolveMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var inner = expression.dissolveMinus(depth: depth);
    if (inner is Minus) {
      return Minus(Tan(inner.expression));
    }
    return Tan(inner);
  }

  @override
  Eq distributeMinus() {
    var inner = expression.distributeMinus();
    if (inner is Minus) {
      return Minus(Tan(inner.expression));
    }
    return Tan(inner);
  }

  @override
  Eq shrink({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.shrink(depth: depth));
  }

  @override
  Eq expandMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.expandMultiplications(depth: depth));
  }

  @override
  Eq expandPowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.expandPowers(depth: depth));
  }

  @override
  Eq distributeExponent({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.distributeExponent(depth: depth));
  }

  @override
  Eq expandDivision({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.expandDivision(depth: depth));
  }

  @override
  Eq reduceDivisions({int? depth}) =>
      Tan(expression.reduceDivisions(depth: depth));

  @override
  Eq combineMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.combineMultiplications(depth: depth));
  }

  @override
  Eq combinePowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.combinePowers(depth: depth));
  }

  @override
  Eq dissolvePowerOfPower({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Tan(expression.dissolvePowerOfPower(depth: depth));
  }

  @override
  Eq factorOutAddition() => Tan(expression.factorOutAddition());

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Tan(expression.substitute(substitutions));

  @override
  bool hasVariable(Variable v) => expression.hasVariable(v);

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    if (thisSimplified is! Tan) {
      return thisSimplified.isSame(other, epsilon);
    }
    other = other.simplify();
    if (other is! Tan) {
      // TODO compare constants
      return false;
    }
    return expression.isSame(other.expression, epsilon);
  }

  /*
  @override
  Eq simplify() {
    var inner = expression.simplify();
    var c = inner.toConstant();
    if (c != null) {
      return Constant(tan(c));
    } else if (inner is Minus) {
      return Minus(Tan(inner.expression));
    }
    return Tan(inner);
  }
   */

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) =>
      'tan(${expression.toString(spec: spec)})';
}
