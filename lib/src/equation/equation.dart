import 'package:equation/equation.dart';

export 'addition.dart';
export 'constant.dart';
export 'imaginary.dart';
export 'minus.dart';
export 'power.dart';
export 'times.dart';
export 'trignometric.dart';
export 'variable.dart';

abstract class Eq {
  const Eq();

  factory Eq.from(dynamic v) {
    if (v is Eq) return v;
    if (v is String) return Variable(v);
    if (v is num) return Constant(v);
    throw ArgumentError('cannot create expression from ${v.runtimeType}');
  }

  factory Eq.fromJson(dynamic json) {
    if(json is String) {
      return Variable(json);
    } else if(json is num) {
      return Constant(json);
    } else if(json is bool) {
      return Constant(json ? 1 : 0);
    } else if(json is! Map) {
      throw ArgumentError('cannot create expression from ${json.runtimeType}');
    }
    final String type = json['type'];
    if(type == EqJsonType.imaginary.name) {
      return i;
    } else if(type == EqJsonType.minus.name) {
      return Minus.fromJson(json);
    } else if(type == EqJsonType.sin.name) {
      return Sin.fromJson(json);
    } else if(type == EqJsonType.cos.name) {
      return Cos.fromJson(json);
    } else if(type == EqJsonType.tan.name) {
      return Tan.fromJson(json);
    } else if(type == EqJsonType.plus.name) {
      return Plus.fromJson(json);
    } else if(type == EqJsonType.times.name) {
      return Times.fromJson(json);
    } else if(type == EqJsonType.power.name) {
      return Power.fromJson(json);
    }
    throw UnsupportedError(type);
  }

  /// Add operator. Creates a [Plus] expression.
  Plus operator +(/*Eq*/ exp) => Plus([this, Eq.from(exp)]);

  /// Subtract operator. Creates a [Minus] expression.
  Plus operator -(/*Eq*/ exp) => Plus([this, -Eq.from(exp)]);

  /// Multiply operator. Creates a [Times] expression.
  Times operator *(/*Eq*/ exp) => Times([this, Eq.from(exp)]);

  /// Divide operator. Creates a [Divide] expression.
  Times operator /(/*Eq*/ exp) =>
      Times([this, Power(Eq.from(exp), Minus(Constant(1)))]);

  /// Power operator. Creates a [Power] expression.
  Power lpow(/*Eq*/ exp) => Power.left(this, Eq.from(exp));

  /// Power operator. Creates a [Power] expression.
  Power pow(/*Eq*/ exp) => Power.right(this, Eq.from(exp));

  /// Unary minus operator. Creates a [Minus] expression.
  Minus operator -() => Minus(this);

  bool isConstant() => toConstant() != null;

  num? toConstant();

  bool isSimpleConstant();

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

  Eq dissolveImaginary();

  Eq shrink({int? depth});

  /// (x + 5) * (x + 8) = x^2 + 13x + 40
  Eq expandMultiplications({int? depth});

  // TODO implement depth
  /// x + (1 + y) - (2 + y) = x - y - 1
  Eq combineAdditions({int? depth});

  Eq factorOutMinus({int? depth});

  /// -(x + y) => -x - y
  Eq distributeMinus();

  /// -(-x) => x
  Eq dissolveMinus({int? depth});

  /// -(a+b) => a+b
  Eq dropMinus();

  /// (a+b)/x = a/x + b/x
  Eq expandDivision({int? depth});

  /// (a+b)^2 = a^2+2ab+b^2
  Eq expandPowers({int? depth});

  /// ((x * y)/z) ** 2 = x**2 * y**2 / z**2
  Eq distributeExponent({int? depth});

  /// x * x = x**2
  Eq combineMultiplications({int? depth});

  /// x ^ 2 * y ^ 2 = (x * y) ^ 2
  Eq combinePowers({int? depth});

  /// (x ^ y) ^ z => x ^ (y * z)
  Eq dissolvePowerOfPower({int? depth});

  Eq factorOutAddition();

  Times multiplicativeTerms();

  Eq reduceDivisions({int? depth});

  (List<Eq>, List<Eq>) separateDivision();

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

  bool canDissolveImaginary();

  bool canShrink();

  bool canCombineAdditions();

  bool canFactorOutAddition();

  bool canCombineMultiplications({int? depth});

  bool canExpandMultiplications();

  // TODO bool canExpandDivision();

  bool canReduceDivisions();

  bool canCombinePowers();

  bool canExpandPowers();

  bool canDissolvePowerOfPower();

  bool canDistributeExponent();

  Simplification? canSimplify();

  Eq simplify({bool equalsZero = false, bool debug = false}) {
    Eq ret = this;
    for (
      Simplification? s = ret.canSimplify();
      s != null;
      s = ret.canSimplify()
    ) {
      if (debug) {
        print('Before $s => ');
      }
      // print('$s: $ret');
      if (s == Simplification.dissolveMinus) {
        ret = ret.dissolveMinus();
      } else if (s == Simplification.dissolveConstants) {
        ret = ret.dissolveConstants();
      } else if (s == Simplification.dissolveImaginary) {
        ret = ret.dissolveImaginary();
      } else if (s == Simplification.shrink) {
        ret = ret.shrink();
      } else if (s == Simplification.combineAdditions) {
        ret = ret.combineAdditions();
      } else if (s == Simplification.combineMultiplications) {
        ret = ret.combineMultiplications();
      } else if (s == Simplification.expandMultiplications) {
        ret = ret.expandMultiplications();
      } else if (s == Simplification.reduceDivisions) {
        ret = ret.reduceDivisions();
      }
      /*else if(s == Simplification.combinePowers) {
        ret = ret.combinePowers();
      }*/
      else if (s == Simplification.expandPowers) {
        ret = ret.expandPowers();
      } else if (s == Simplification.dissolvePowerOfPower) {
        ret = ret.dissolvePowerOfPower();
      } else if (s == Simplification.distributeExponent) {
        ret = ret.distributeExponent();
      } else {
        throw UnimplementedError('$s');
      }
      if (equalsZero) {
        ret = ret.dropMinus();
      }
      if (debug) {
        print('$ret');
      }
    }
    return ret;
  }

  dynamic toJson();

  static Constant c(num value) => Constant(value);

  static Variable v(String name) => Variable(name);
}

enum Simplification {
  dissolveMinus,
  dissolveConstants,
  dissolveImaginary,
  shrink,
  combineAdditions,
  combineMultiplications,
  expandMultiplications,
  // expandDivision,
  reduceDivisions,
  // combinePowers,
  expandPowers,
  dissolvePowerOfPower,
  distributeExponent,
}

enum EqJsonType {
  constant,
  imaginary,
  variable,
  minus,
  plus,
  times,
  power,
  cos,
  sin,
  tan,
}

extension NumExtension on num {
  Eq pow(exp) => Eq.c(this).pow(exp);

  Eq lpow(exp) => Eq.c(this).lpow(exp);
}

