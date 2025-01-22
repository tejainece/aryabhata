import 'package:equation/equation.dart';

class Minus extends Eq {
  final Eq expression;

  Minus(this.expression);

  @override
  Eq simplify() {
    var inner = expression.simplify();
    if (inner is Minus) {
      return inner.expression;
    }
    return Minus(inner);
  }

  @override
  double? toConstant() {
    final v = expression.simplify();
    if (v is! Constant) return null;
    return -v.value;
  }

  @override
  (double, Eq) separateConstant() {
    final (c, ne) = expression.separateConstant();
    return (-c, ne);
  }

  @override
  Eq factorOutMinus() {
    var inner = expression.factorOutMinus();
    if (inner is Minus) {
      return inner.expression;
    }
    return Minus(inner);
  }

  @override
  Eq dissolveMinus() {
    Eq ex = expression.dissolveMinus();
    if (ex is Minus) {
      return ex.expression;
    }
    return Minus(ex);
  }

  @override
  List<Eq> multiplicativeTerms() => [this];

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
  Eq combineAddition() => Minus(expression.combineAddition());

  @override
  Eq expandMultiplications({int? depth}) =>
      Minus(expression.expandMultiplications(depth: depth));

  @override
  Eq distributeExponent({int? depth}) =>
      Minus(expression.distributeExponent(depth: depth));

  @override
  Eq simplifyDivisionOfAddition({int? depth}) =>
      Minus(expression.simplifyDivisionOfAddition(depth: depth));

  @override
  Eq combineMultiplications({int? depth}) =>
      Minus(expression.combineMultiplications());

  @override
  Eq combinePowers({int? depth}) => Minus(expression.combinePowers());

  @override
  Eq factorOutAddition() =>
      Minus(expression.factorOutAddition()).dissolveMinus();

  @override
  Eq withConstant(double c) {
    var ret = expression.withConstant(c);
    return ret is Minus ? ret.expression : Minus(ret);
  }

  @override
  bool hasVariable(Variable v) => expression.hasVariable(v);

  @override
  Eq? tryCancelDivision(Eq other) {
    // TODO: implement tryDivide
    throw UnimplementedError();
  }

  @override
  bool get isSingle => false;

  @override
  bool get isLone => expression.isLone;

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
  String toString() {
    final exp = expression;
    if (exp is Constant) {
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
