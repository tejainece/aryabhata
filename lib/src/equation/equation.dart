import 'divide.dart';
import 'plus.dart';
import 'power.dart';
import 'times.dart';
import 'variable.dart';

export 'divide.dart';
export 'imaginary.dart';
export 'plus.dart';
export 'power.dart';
export 'times.dart';
export 'trignometric.dart';
export 'variable.dart';

class Quadratic {
  final Eq a;
  final Eq b;
  final Eq c;

  Quadratic(this.a, this.b, this.c);

  @override
  String toString() => 'a= $a, b= $b, c= $c';
}

abstract class Eq {
  const Eq();

  factory Eq.from(dynamic v) {
    if (v is Eq) return v;
    if (v is String) return Variable(v);
    if (v is double) return C(v);
    throw ArgumentError('cannot create expression from ${v.runtimeType}');
  }

  /// Add operator. Creates a [Plus] expression.
  Plus operator +(Eq exp) => Plus([this, exp]);

  /// Subtract operator. Creates a [Minus] expression.
  Plus operator -(Eq exp) => Plus([this, -exp]);

  /// Multiply operator. Creates a [Times] expression.
  Times operator *(Eq exp) => Times([this, exp]);

  /// Divide operator. Creates a [Divide] expression.
  Divide operator /(Eq exp) => Divide([this, exp]);

  /// Power operator. Creates a [Power] expression.
  Power pow(Eq exp) => Power([this, exp]);

  /// Unary minus operator. Creates a [UnaryMinus] expression.
  UnaryMinus operator -() => UnaryMinus(this);

  Eq substitute(Map<String, Eq> substitutions);

  Eq simplify();

  bool isSame(Eq other, [double epsilon = 1e-6]);

  bool isConstant() => toConstant() != null;

  double? toConstant() {
    var s = simplify();
    if (s is C) return s.value;
    if (s is UnaryMinus) return s.toConstant();
    return null;
  }

  bool hasVariable(Variable v) => false;

  (C, Eq) separateConstant() => (C(1), this);

  Eq expandPlus() => this;

  Eq expandMultiplications();

  Eq expandDivisions();

  Eq simplifyPowers();

  Eq simplifyMultiplications();

  Quadratic asQuadratic(Variable x) {
    // TODO handle other types
    var simplified = simplify();
    if (simplified is! Plus) {
      throw UnimplementedError();
    }
    Eq a = C(0);
    Eq b = C(0);
    Eq c = C(0);

    for (var term in simplified.expressions) {
      if (!term.hasVariable(x)) {
        c += term;
        continue;
      }
      var tmp = (term / x.pow(C(2))).simplify();
      if (!tmp.hasVariable(x)) {
        a += tmp;
        continue;
      }
      tmp = (term / x).simplify();
      if (!tmp.hasVariable(x)) {
        b += tmp;
        continue;
      }
      throw UnsupportedError('$term not a polynomial');
    }

    return Quadratic(a, b, c);
  }

  static Eq addTerms(Eq a, Eq b) {
    a = a.simplify();
    b = b.simplify();

    var (aC, aSimplified) = a.separateConstant();
    var (bC, bSimplified) = b.separateConstant();

    if (!aSimplified.isSame(bSimplified)) {
      return Plus([aSimplified, bSimplified]);
    }
    if (aSimplified is C) {
      return C((aC.value + bC.value) * aSimplified.value).simplify();
    } else if (aSimplified is UnaryMinus) {
      final v = aSimplified.expression;
      if (v is C) {
        return UnaryMinus(C((aC.value + bC.value) * v.value)).simplify();
      }
    }
    return Times([(aC + bC).simplify(), aSimplified]);
  }

  static Eq? tryAddTerms(Eq a, Eq b) {
    a = a.simplify();
    b = b.simplify();

    var (aC, aSimplified) = a.separateConstant();
    var (bC, bSimplified) = b.separateConstant();

    if (!aSimplified.isSame(bSimplified)) {
      return null;
    }
    if (aSimplified is C) {
      return C((aC.value + bC.value) * aSimplified.value).simplify();
    } else if (aSimplified is UnaryMinus) {
      final v = aSimplified.expression;
      if (v is C) {
        return UnaryMinus(C((aC.value + bC.value) * v.value)).simplify();
      }
    }
    return Times([(aC + bC).simplify(), aSimplified]);
  }
}

abstract class Value extends Eq {}

class C extends Eq implements Value {
  final double value;

  C(this.value);

  @override
  Eq substitute(Map<String, Eq> substitutions) => this;

  @override
  Eq simplify() {
    if (value.isNegative) {
      return UnaryMinus(C(-value));
    }
    return this;
  }

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) =>
      other is C && (other.value - value).abs() < epsilon;

  @override
  bool isConstant() => true;

  @override
  double toConstant() => value;

  @override
  bool hasVariable(Variable v) => false;

  @override
  (C, Eq) separateConstant() => (this, C(1));

  @override
  Eq expandMultiplications() => this;

  @override
  Eq simplifyPowers() => this;

  @override
  Eq expandDivisions() => this;

  @override
  Eq simplifyMultiplications() => this;

  @override
  String toString() => value.stringMaybeInt;
}

class UnaryMinus extends Eq {
  final Eq expression;

  UnaryMinus(this.expression);

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      UnaryMinus(expression.substitute(substitutions));

  @override
  Eq simplify() {
    var inner = expression.simplify();
    if (inner is UnaryMinus) {
      return inner.expression;
    }
    return UnaryMinus(inner);
  }

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) {
    other = other.simplify();
    if (other is! UnaryMinus) {
      // TODO other is Plus
      // TODO exp is Plus
      return false;
    }
    return expression.isSame(other.expression, epsilon);
  }

  @override
  double? toConstant() {
    final v = expression.simplify();
    if (v is! C) return null;
    return -v.value;
  }

  @override
  bool hasVariable(Variable v) => expression.hasVariable(v);

  @override
  (C, Eq) separateConstant() {
    final (c, ne) = expression.separateConstant();
    return (C(-c.value), ne);
  }

  @override
  Eq expandMultiplications() => UnaryMinus(expression.expandMultiplications());

  @override
  Eq simplifyPowers() => UnaryMinus(expression.simplifyPowers());

  @override
  Eq expandDivisions() => UnaryMinus(expression.expandDivisions());

  @override
  Eq simplifyMultiplications() =>
      UnaryMinus(expression.simplifyMultiplications());

  @override
  String toString() {
    final exp = expression;
    if (exp is C) {
      if (exp.value.isNegative) {
        return exp.toString();
      }
      return '-$exp';
    } else if (exp is Variable) {
      return '-$exp';
    }
    return '-($expression)';
  }
}

extension DoubleExt on double {
  bool get isInt => (this - round()).abs() < 1e-8;

  String get stringMaybeInt => isInt ? round().toString() : toString();
}
