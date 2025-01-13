

import 'dart:math';

import 'package:equation/equation.dart';

abstract class Trig extends Eq {}

class Cos extends Eq implements Trig {
  final Eq exp;

  Cos(this.exp);

  @override
  Eq simplify() {
    var inner = exp.simplify();
    var c = inner.toConstant();
    if (c != null) {
      return C(cos(c));
    } else if (inner is UnaryMinus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }

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
    return thisSimplified.exp.isSame(other.exp, epsilon);
  }

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Cos(exp.substitute(substitutions));

  @override
  double? toConstant() {
    final c = exp.simplify().toConstant();
    if (c == null) return null;
    return cos(c);
  }

  @override
  bool hasVariable(Variable v) => exp.hasVariable(v);

  @override
  Eq expandMultiplications() => Cos(exp.expandMultiplications());

  @override
  Eq simplifyPowers() => Cos(exp.simplifyPowers());

  @override
  Eq expandDivisions() => Cos(exp.expandDivisions());

  @override
  Eq simplifyMultiplications() => Cos(exp.simplifyMultiplications());

  @override
  String toString() => 'cos($exp)';
}

class Sin extends Eq implements Trig {
  final Eq exp;

  Sin(this.exp);

  @override
  Eq simplify() {
    var inner = exp.simplify();
    final c = inner.toConstant();
    if (c != null) {
      return C(sin(c));
    } else if (inner is UnaryMinus) {
      return UnaryMinus(Sin(inner.expression));
    }
    return Sin(inner);
  }

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
    return thisSimplified.exp.isSame(other.exp, epsilon);
  }

  @override
  double? toConstant() {
    final c = exp.simplify().toConstant();
    if (c == null) return null;
    return sin(c);
  }

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Sin(exp.substitute(substitutions));

  @override
  bool hasVariable(Variable v) => exp.hasVariable(v);

  @override
  Eq expandMultiplications() => Sin(exp.expandMultiplications());

  @override
  Eq simplifyPowers() => Sin(exp.simplifyPowers());

  @override
  Eq expandDivisions() => Sin(exp.expandDivisions());

  @override
  Eq simplifyMultiplications() => Sin(exp.simplifyMultiplications());

  @override
  String toString() => 'sin($exp)';
}

class Tan extends Eq implements Trig {
  final Eq exp;

  Tan(this.exp);

  @override
  Eq simplify() {
    var inner = exp.simplify();
    var c = inner.toConstant();
    if (c != null) {
      return C(tan(c));
    } else if (inner is UnaryMinus) {
      return UnaryMinus(Tan(inner.expression));
    }
    return Tan(inner);
  }

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
    return exp.isSame(other.exp, epsilon);
  }

  @override
  double? toConstant() {
    final c = exp.simplify().toConstant();
    if (c == null) return null;
    return tan(c);
  }

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Tan(exp.substitute(substitutions));

  @override
  bool hasVariable(Variable v) => exp.hasVariable(v);

  @override
  Eq expandMultiplications() => Tan(exp.expandMultiplications());

  @override
  Eq simplifyPowers() => Tan(exp.simplifyPowers());

  @override
  Eq expandDivisions() => Tan(exp.expandDivisions());

  @override
  Eq simplifyMultiplications() => Tan(exp.simplifyMultiplications());

  @override
  String toString() => 'tan($exp)';
}