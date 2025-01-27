import 'package:equation/src/printer.dart';

import 'addition.dart';
import 'constant.dart';
import 'minus.dart';
import 'power.dart';
import 'times.dart';
import 'variable.dart';

export 'addition.dart';
export 'constant.dart';
export 'imaginary.dart';
export 'minus.dart';
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
    if (v is double) return Constant(v);
    throw ArgumentError('cannot create expression from ${v.runtimeType}');
  }

  /// Add operator. Creates a [Plus] expression.
  Plus operator +(Eq exp) => Plus([this, exp]);

  /// Subtract operator. Creates a [Minus] expression.
  Plus operator -(Eq exp) => Plus([this, -exp]);

  /// Multiply operator. Creates a [Times] expression.
  Times operator *(Eq exp) => Times([this, exp]);

  /// Divide operator. Creates a [Divide] expression.
  // TODO
  Times operator /(Eq exp) => Times([this, Power(exp, Minus(Constant(1)))]);

  /// Power operator. Creates a [Power] expression.
  Power lpow(Eq exp) => Power.left(this, exp);

  /// Power operator. Creates a [Power] expression.
  Power pow(Eq exp) => Power.right(this, exp);

  /// Unary minus operator. Creates a [Minus] expression.
  Minus operator -() => Minus(this);

  bool isConstant() => toConstant() != null;

  num? toConstant();

  Eq withConstant(num c) {
    if (c.abs() < 1e-6) {
      return Constant(0);
    }
    if ((c.abs() - 1).abs() < 1e-6) {
      return c.isNegative ? Minus(this) : this;
    }
    return c.isNegative
        ? Minus(Times([Constant(-c), this]))
        : Times([Constant(c), this]);
  }

  (num, Eq) separateConstant();

  Eq dissolveConstants({int? depth});

  /// (x + 5) * (x + 8) = x^2 + 13x + 40
  Eq expandMultiplications({int? depth});

  /// x + (1 + y) - (2 + y) = x - y - 1
  Eq combineAddition();

  Eq factorOutMinus({int? depth});

  /// -(x + y) => -x - y
  Eq distributeMinus();

  /// -(-x) => x
  Eq dissolveMinus({int? depth});

  /// -(a+b) => a+b
  Eq dropMinus();

  /// (a+b)/x = a/x + b/x
  Eq expandDivision({int? depth});

  /// ((x * y)/z) ** 2 = x**2 * y**2 / z**2
  Eq distributeExponent({int? depth});

  /// x * x = x**2
  Eq combineMultiplications({int? depth});

  /// x ^ 2 * y ^ 2 = (x * y) ^ 2
  Eq combinePowers({int? depth});

  /// (x ^ y) ^ z => x ^ (y * z)
  Eq dissolvePowerOfPower({int? depth});

  Eq factorOutAddition();

  List<Eq> multiplicativeTerms();

  Eq? tryCancelDivision(Eq other);

  bool get isLone;

  bool get isSingle;

  bool hasVariable(Variable v);

  bool isSame(Eq other, [double epsilon = 1e-6]);

  Eq substitute(Map<String, Eq> substitutions);

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()});

  bool canDissolveConstants();

  bool canDissolveMinus();

  bool canCombineMultiplications();

  bool canCombinePowers();

  bool canDissolvePowerOfPower();

  bool canDistributeExponent();

  Simplification? canSimplify();

  Eq simplify() {
    Eq ret = this;
    for (
      Simplification? s = ret.canSimplify();
      s != null;
      s = ret.canSimplify()
    ) {
      if (s == Simplification.dissolveMinus) {
        ret = ret.dissolveMinus();
      } else if (s == Simplification.dissolveConstants) {
        ret = ret.dissolveConstants();
      } else if (s == Simplification.combineAdditions) {
        ret = ret.combineAddition();
      } else if (s == Simplification.combineMultiplications) {
        ret = ret.combineMultiplications();
      } else if(s == Simplification.combinePowers) {
        ret = ret.combinePowers();
      } else if (s == Simplification.dissolvePowerOfPower) {
        ret = ret.dissolvePowerOfPower();
      } else if(s == Simplification.distributeExponent) {
        ret = ret.distributeExponent();
      } else {
        throw UnimplementedError('$s');
      }
    }
    return ret;
  }

  Quadratic asQuadratic(Variable x) {
    // TODO handle other types
    var simplified = simplify();
    if (simplified is! Plus) {
      throw UnimplementedError();
    }
    Eq a = Constant(0);
    Eq b = Constant(0);
    Eq c = Constant(0);

    for (var term in simplified.expressions) {
      if (!term.hasVariable(x)) {
        c += term;
        continue;
      }
      Eq tmp = (term / x.pow(Constant(2)));
      tmp = tmp.simplify();
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

  /*
  // TODO handle negatives properly
  static Eq addTerms(Eq a, Eq b) {
    a = a.simplify();
    b = b.simplify();

    var (aC, aSimplified) = a.separateConstant();
    var (bC, bSimplified) = b.separateConstant();

    if (!aSimplified.isSame(bSimplified)) {
      return Plus([aSimplified, bSimplified]);
    }
    if (aSimplified is Constant) {
      return Constant((aC + bC) * aSimplified.value).simplify();
    } else if (aSimplified is Minus) {
      final v = aSimplified.expression;
      if (v is Constant) {
        return Minus(Constant((aC + bC) * v.value)).simplify();
      }
    }
    return Times([Constant(aC + bC), aSimplified]);
  }
   */

  static Constant c(num value) => Constant(value);

  static Variable v(String name) => Variable(name);
}

enum Simplification {
  dissolveMinus,
  dissolveConstants,
  combineAdditions,
  combineMultiplications,
  combinePowers,
  dissolvePowerOfPower,
  distributeExponent,
}
