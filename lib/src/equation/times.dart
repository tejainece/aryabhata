import 'dart:math';

import 'package:equation/equation.dart';

class Times extends Eq {
  final List<Eq> expressions;

  Times._(this.expressions) : assert(expressions.isNotEmpty);

  factory Times(Iterable<Eq> expressions) {
    final ret = <Eq>[];
    for (final e in expressions) {
      if (e is Times) {
        ret.addAll(e.expressions);
      } else {
        ret.add(e);
      }
    }
    return Times._(ret);
  }

  @override
  Eq simplify() {
    return Times(
      expressions.map((e) => e.simplify()).toList(),
    ).combinePowers().combineMultiplications();
  }

  @override
  (double, Eq) separateConstant() {
    double c = 1.0;
    final ret = <Eq>[];
    for (final e in expressions) {
      final (ec, eeq) = e.separateConstant();
      if (ec.abs() < 1e-6) return (0, Constant(0));
      c *= ec;
      if (eeq is Constant) {
        c *= eeq.value;
      } else if (eeq is Times) {
        ret.addAll(eeq.expressions);
      } else {
        ret.add(eeq);
      }
    }
    if (ret.isEmpty) {
      return (c, Constant(1.0));
    } else if (ret.length == 1) {
      return (c, ret[0]);
    }
    return (c, Times(ret));
  }

  @override
  Eq dissolveMinus() {
    bool isMinus = false;
    final ret = <Eq>[];
    for (var e in expressions) {
      e = e.dissolveMinus();
      if (e is Minus) {
        isMinus = !isMinus;
        ret.add(e.expression);
      } else {
        ret.add(e);
      }
    }
    if (isMinus) {
      return Minus(Times(ret));
    }
    return Times(ret);
  }

  @override
  Eq distributeMinus() => dissolveMinus().distributeMinus();

  @override
  Eq factorOutMinus() {
    final ret = expressions.map((e) => e.factorOutMinus()).toList();
    bool isMinus = false;
    for (int i = 0; i < ret.length; i++) {
      if (ret[i] is! Minus) {
        continue;
      }
      ret[i] = (ret[i] as Minus).expression;
      isMinus = !isMinus;
    }
    if (isMinus) {
      return Minus(Times._(ret));
    }
    return Times._(ret);
  }

  @override
  Eq combineAddition() => Times(expressions.map((e) => e.combineAddition()));

  /// (x + 5) * (x + 8) = x^2 + 13x + 40
  @override
  Eq expandMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }

    Plus ret = Plus([expressions.first]);
    for (final e in expressions.skip(1)) {
      ret = ret.expandingMultiply(e);
    }
    if (ret.expressions.length == 1) {
      return ret.expressions.first;
    }
    return ret;
  }

  @override
  Eq distributeExponent({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }
    return Times(expressions.map((e) => e.distributeExponent(depth: depth)));
  }

  @override
  Eq simplifyDivisionOfAddition({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }
    return Times(
      expressions.map((e) => e.simplifyDivisionOfAddition(depth: depth)),
    );
  }

  @override
  Eq combineMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }
    final (c, eq) = separateConstant();
    if (eq is! Times) {
      return eq.combineMultiplications(depth: depth).withConstant(c);
    }
    final ret = eq.expressions.toList();
    for (int i = 0; i < ret.length; i++) {
      int n = 1;
      for (int j = i + 1; j < ret.length; j++) {
        // TODO use better way to detect detect real number powers, hidden powers
        if (!ret[i].isSame(ret[j])) {
          continue;
        }
        n++;
        ret.removeAt(j);
        j--;
      }
      if (n > 1) {
        ret[i] = Power(ret[i], Constant(n.toDouble()));
      }
    }
    if (ret.isEmpty) {
      return Constant(c).dissolveMinus();
    } else if (ret.length == 1) {
      return ret[0].withConstant(c);
    } else {
      return Times(ret).withConstant(c);
    }
  }

  @override
  Eq combinePowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth <= 0) return this;
    }
    final ret = expressions.toList();
    for (int i = 0; i < ret.length; i++) {
      final a = ret[i];
      if (a is! Power) continue;
      final e = a.exponent;
      for (int j = i + 1; j < ret.length; j++) {
        final b = ret[j];
        if (b is! Power) continue;
        if (!b.exponent.isSame(e)) continue;
        ret[i] = Power(Times([a.base, b.base]), e);
        ret.removeAt(j);
        j--;
      }
    }
    if (ret.isEmpty) {
      return Constant(1);
    } else if (ret.length == 1) {
      return ret[0];
    } else {
      return Times(ret);
    }
  }

  @override
  Eq factorOutAddition() =>
      Times(expressions.map((e) => e.factorOutAddition()));

  @override
  List<Eq> multiplicativeTerms() => expressions.toList();

  @override
  Eq? tryCancelDivision(Eq other) {
    assert(other.isSingle);
    final ret = expressions.toList();
    for (int i = 0; i < ret.length; i++) {
      final v = ret[i];
      final d = v.tryCancelDivision(other);
      if (d == null) continue;
      if (!d.isSame(one)) {
        ret[i] = d;
      } else {
        ret.removeAt(i);
      }
      return Times(ret);
    }
    return null;
  }

  @override
  bool get isSingle => false;

  @override
  bool get isLone {
    if (expressions.length == 1) {
      return expressions[0].isLone;
    }
    // return expressions.every((e) => e.isLone);
    return false;
  }

  @override
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Times(expressions.map((e) => e.substitute(substitutions)));

  @override
  bool isSame(Eq otherSimplified, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    if (thisSimplified is! Times) {
      return thisSimplified.isSame(otherSimplified, epsilon);
    }
    otherSimplified = otherSimplified.simplify();
    if (otherSimplified is! Times) {
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

  // TODO only bracket when necessary
  @override
  String toString({bool paren = false}) {
    final numerators = <Eq>[];
    final denominators = <Eq>[];
    for (final e in expressions) {
      if (e is Power) {
        final div = e.toDenominator;
        if (div != null) {
          denominators.add(div);
          continue;
        }
      }
      numerators.add(e);
    }

    final sb = StringBuffer();
    if (Times(numerators).isLone) {
      sb.write(numerators.join('*'));
    } else {
      if (!paren) sb.write('(');
      sb.write(numerators.join('*'));
      if (!paren) sb.write(')');
    }
    if (denominators.isNotEmpty) {
      sb.write('/');
      if (Times(denominators).isLone) {
        sb.write(denominators.join('*'));
      } else {
        sb.write('(');
        for (int i = 0; i < denominators.length; i++) {
          final d = denominators[i];
          if (d is! Times) {
            sb.write(d);
          } else {
            sb.write(d.toString(paren: true));
          }
          if (i < denominators.length - 1) {
            sb.write('*');
          }
        }
        sb.write(')');
      }
    }
    return sb.toString();
  }
}
