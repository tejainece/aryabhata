import 'package:equation/equation.dart';
import 'package:number_factorization/number_factorization.dart';

class Plus extends Eq {
  final List<Eq> expressions;

  Plus._(this.expressions) : assert(expressions.isNotEmpty);

  factory Plus(Iterable<Eq> expressions) {
    final ret = <Eq>[];
    for (final e in expressions) {
      if (e is Plus) {
        ret.addAll(e.expressions);
      } else {
        ret.add(e);
      }
    }
    return Plus._(ret);
  }

  @override
  Eq substitute(Map<String, Eq> substitutions) {
    return Plus(expressions.map((e) => e.substitute(substitutions)).toList());
  }

  @override
  Eq simplify() =>
      Plus(expressions.map((e) => e.simplify()).toList()).combineAddition();

  @override
  Eq combineAddition() {
    var ret = <Eq>[];
    for (final term in expressions) {
      if (term is Plus) {
        ret.addAll(term.expressions);
        continue;
      } else if (term is Minus) {
        final inside = term.expression;
        if (inside is Plus) {
          ret.addAll(
            inside.expressions.map((e) => Minus(e).factorOutMinus()).toList(),
          );
          continue;
        }
      }
      ret.add(term);
    }
    for (int i = 0; i < ret.length; i++) {
      for (int j = i + 1; j < ret.length; j++) {
        final s = _simplify(ret[i], ret[j]);
        if (s != null) {
          ret[i] = s;
          ret.removeAt(j);
          j--;
          break;
        }
      }
    }
    if (ret.length == 1) {
      return ret[0];
    }
    return Plus(ret);
  }

  @override
  Eq factorOutAddition() {
    throw UnimplementedError();
    /*
    final (c, eq) = separateConstant();

    // TODO

    if (c == 1) {
      return eq;
    }
    return Times([c, eq]);
    */
  }

  Plus expandingMultiply(Eq s) {
    if (s is! Plus) {
      s = Plus([s]);
    }
    var ret = <Eq>[];
    for (var e1 in expressions) {
      for (var e2 in s.expressions) {
        ret.add(e1 * e2);
      }
    }
    return Plus(ret);
  }

  Eq equationOf(Variable v) {
    var left = <Eq>[];
    var rightExps = <Eq>[];
    for (var e in expressions) {
      if (e.hasVariable(v)) {
        left.add(e);
        continue;
      }
      rightExps.add(Minus(e));
    }
    if (left.isEmpty) {
      return Constant(0);
    }
    if (left.length > 1) {
      throw UnimplementedError('Only linear equations are supported');
    }
    Eq right;
    if (rightExps.isEmpty) {
      right = Constant(0);
    } else if (rightExps.length == 1) {
      right = rightExps[0];
    } else {
      right = Plus(rightExps);
    }
    final e = left[0];
    if (e is! Times) {
      throw UnimplementedError();
    }
    for (final item in e.expressions) {
      if (!item.hasVariable(v)) {
        right = right / item;
        continue;
      }
      if (item is! Variable) {
        throw UnimplementedError();
      }
    }
    return right;
  }

  @override
  (double, Plus) separateConstant() {
    final separated = expressions.map((e) => e.separateConstant()).toList();
    final constants = separated.map((e) => e.$1).toList();
    double gcd = gcdAll(constants);
    // Separate sign
    final numNeg = constants.fold(
      0,
      (int v, double c) => c.isNegative ? ++v : v,
    );
    if (numNeg > constants.length / 2) {
      gcd = -gcd;
    }
    return (
      gcd,
      Plus(
        separated.map((e) => (Constant(e.$1 / gcd) * e.$2).simplify()).toList(),
      ),
    );
  }

  @override
  Eq expandMultiplications() =>
      Plus(expressions.map((e) => e.expandMultiplications()).toList());

  @override
  Eq distributeExponent() =>
      Plus(expressions.map((e) => e.distributeExponent()).toList());

  @override
  Eq simplifyDivisionOfAddition() =>
      Plus(expressions.map((e) => e.simplifyDivisionOfAddition()).toList());

  @override
  Eq combineMultiplicationsAndPowers() => Plus(
    expressions.map((e) => e.combineMultiplicationsAndPowers()).toList(),
  );

  @override
  bool isSame(Eq otherSimplified, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    if (thisSimplified is! Plus) {
      return thisSimplified.isSame(otherSimplified, epsilon);
    }
    otherSimplified = otherSimplified.simplify();
    if (otherSimplified is! Plus) {
      // TODO handle UnaryMinus
      return false;
    }
    if (thisSimplified.expressions.length !=
        otherSimplified.expressions.length) {
      return false;
    }
    final otherExps = otherSimplified.expressions.toList();
    for (final item in thisSimplified.expressions) {
      final match = otherExps.indexWhere(
        (otherItem) => otherItem.isSame(item, epsilon),
      );
      if (match == -1) {
        return false;
      }
      otherExps.removeAt(match);
    }
    return true;
  }

  @override
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write(expressions.first.toString());
    for (int i = 1; i < expressions.length; i++) {
      final (c, e) = expressions[i].separateConstant();
      if (c.isNegative) {
        sb.write('-');
      } else {
        sb.write('+');
      }
      bool hasC = false;
      if (c.abs() != 1) {
        sb.write(c.abs().stringMaybeInt);
        hasC = true;
      }
      if (!e.isSame(Constant(1))) {
        if (hasC) sb.write('*');
        sb.write(e);
      }
    }
    return sb.toString();
  }

  static Eq? _simplify(Eq f, Eq s) {
    if (f is Constant && s is Constant) {
      return Constant(f.value + s.value);
    }
    final u = tryAddTerms(f, s);
    if (u != null) {
      return u;
    }
    return null;
  }

  static Eq? tryAddTerms(Eq a, Eq b) {
    a = a.simplify();
    b = b.simplify();

    var (aC, aSimplified) = a.separateConstant();
    var (bC, bSimplified) = b.separateConstant();
    if (!aSimplified.isSame(bSimplified)) return null;

    if (aSimplified is Constant) {
      return Constant((aC + bC) * aSimplified.value).simplify();
    }
    return aSimplified.withConstant(aC + bC);
  }

  @override
  Eq factorOutMinus() =>
      Plus(expressions.map((e) => e.factorOutMinus()).toList());

  @override
  Eq dissolveMinus() =>
      Plus(expressions.map((e) => e.dissolveMinus()).toList());

  @override
  Eq distributeMinus() =>
      Plus(expressions.map((e) => e.distributeMinus()).toList());

  @override
  bool get isLone {
    if (expressions.length != 1) return false;
    return expressions[0].isLone;
  }
}
