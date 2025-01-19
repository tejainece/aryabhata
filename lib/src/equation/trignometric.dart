import 'dart:math';

import 'package:equation/equation.dart';

abstract class Trig extends Eq {
  @override
  bool get isLone => true;
}

class Cos extends Trig {
  final Eq exp;

  Cos(this.exp);

  @override
  Eq simplify() {
    var inner = exp.simplify();
    var c = inner.toConstant();
    if (c != null) {
      return Constant(cos(c));
    } else if (inner is Minus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }

  @override
  double? toConstant() {
    final c = exp.simplify().toConstant();
    if (c == null) return null;
    return cos(c);
  }

  @override
  Eq factorOutMinus() {
    var inner = exp.factorOutMinus();
    if (inner is Minus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }

  @override
  Eq dissolveMinus() {
    var inner = exp.dissolveMinus();
    if (inner is Minus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }

  @override
  Eq distributeMinus() {
    var inner = exp.distributeMinus();
    if (inner is Minus) {
      return Cos(inner.expression);
    }
    return Cos(inner);
  }

  @override
  Eq combineAddition() => Cos(exp.combineAddition());

  @override
  Eq expandMultiplications() => Cos(exp.expandMultiplications());

  @override
  Eq distributeExponent() => Cos(exp.distributeExponent());

  @override
  Eq simplifyDivisionOfAddition() => Cos(exp.simplifyDivisionOfAddition());

  @override
  Eq combineMultiplicationsAndPowers() =>
      Cos(exp.combineMultiplicationsAndPowers());

  @override
  Eq factorOutAddition() => Cos(exp.factorOutAddition());

  @override
  bool hasVariable(Variable v) => exp.hasVariable(v);

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Cos(exp.substitute(substitutions));

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
  String toString() => 'cos($exp)';
}

class Sin extends Trig {
  final Eq exp;

  Sin(this.exp);

  @override
  Eq simplify() {
    var inner = exp.simplify();
    final c = inner.toConstant();
    if (c != null) {
      return Constant(sin(c));
    } else if (inner is Minus) {
      return Minus(Sin(inner.expression));
    }
    return Sin(inner);
  }

  @override
  double? toConstant() {
    final c = exp.simplify().toConstant();
    if (c == null) return null;
    return sin(c);
  }

  @override
  Eq combineAddition() => Sin(exp.combineAddition());

  @override
  Eq factorOutMinus() {
    var inner = exp.factorOutMinus();
    if (inner is Minus) {
      return Minus(Sin(inner.expression));
    }
    return Sin(inner);
  }

  @override
  Eq dissolveMinus() {
    var inner = exp.dissolveMinus();
    if (inner is Minus) {
      return Minus(Sin(inner.expression));
    }
    return Sin(inner);
  }

  @override
  Eq distributeMinus() {
    var inner = exp.distributeMinus();
    if (inner is Minus) {
      return Minus(Sin(inner.expression));
    }
    return Sin(inner);
  }

  @override
  Eq expandMultiplications() => Sin(exp.expandMultiplications());

  @override
  Eq distributeExponent() => Sin(exp.distributeExponent());

  @override
  Eq simplifyDivisionOfAddition() => Sin(exp.simplifyDivisionOfAddition());

  @override
  Eq combineMultiplicationsAndPowers() =>
      Sin(exp.combineMultiplicationsAndPowers());

  @override
  Eq factorOutAddition() => Sin(exp.factorOutAddition());

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Sin(exp.substitute(substitutions));

  @override
  bool hasVariable(Variable v) => exp.hasVariable(v);

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
  String toString() => 'sin($exp)';
}

class Tan extends Trig {
  final Eq exp;

  Tan(this.exp);

  @override
  Eq simplify() {
    var inner = exp.simplify();
    var c = inner.toConstant();
    if (c != null) {
      return Constant(tan(c));
    } else if (inner is Minus) {
      return Minus(Tan(inner.expression));
    }
    return Tan(inner);
  }

  @override
  double? toConstant() {
    final c = exp.simplify().toConstant();
    if (c == null) return null;
    return tan(c);
  }

  @override
  Eq combineAddition() => Tan(exp.combineAddition());

  @override
  Eq factorOutMinus() {
    var inner = exp.factorOutMinus();
    if (inner is Minus) {
      return Minus(Tan(inner.expression));
    }
    return Tan(inner);
  }

  @override
  Eq dissolveMinus() {
    var inner = exp.dissolveMinus();
    if (inner is Minus) {
      return Minus(Tan(inner.expression));
    }
    return Tan(inner);
  }

  @override
  Eq distributeMinus() {
    var inner = exp.distributeMinus();
    if (inner is Minus) {
      return Minus(Tan(inner.expression));
    }
    return Tan(inner);
  }

  @override
  Eq expandMultiplications() => Tan(exp.expandMultiplications());

  @override
  Eq distributeExponent() => Tan(exp.distributeExponent());

  @override
  Eq simplifyDivisionOfAddition() => Tan(exp.simplifyDivisionOfAddition());

  @override
  Eq combineMultiplicationsAndPowers() =>
      Tan(exp.combineMultiplicationsAndPowers());

  @override
  Eq factorOutAddition() => Tan(exp.factorOutAddition());

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Tan(exp.substitute(substitutions));

  @override
  bool hasVariable(Variable v) => exp.hasVariable(v);

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
  String toString() => 'tan($exp)';
}
