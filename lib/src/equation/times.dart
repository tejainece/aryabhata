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
    ).combineMultiplicationsAndPowers();
    /*double c = 1;
    final ret = <Eq>[];
    for (final e in expressions) {
      final (ec, eeq) = e.simplify().separateConstant();
      if (ec.abs() < 1e-6) return Constant(0);
      c *= ec;
      if (eeq is Constant) {
        // Do nothing
      } else if (eeq is Times) {
        ret.addAll(eeq.expressions);
      } else {
        ret.add(eeq);
      }
    }
    if (c.abs() < 1e-6) return Constant(0.0);
    // Detect powers
    // TODO detect real powers, hidden powers
    if (ret.isEmpty) return Constant(c).dissolveMinus();
    Eq eq = Times(ret).combineMultiplicationsAndPowers();
    if ((c.abs() - 1).abs() < 1e-6) {
      return c.isNegative ? Minus(eq) : eq;
    }
    return c.isNegative
        ? Minus(Times([Constant(c), eq]))
        : Times([Constant(c), eq]);*/
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
  Eq combineAddition() =>
      Times(expressions.map((e) => e.combineAddition()).toList());

  /// (x + 5) * (x + 8) = x^2 + 13x + 40
  @override
  Eq expandMultiplications() {
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
  Eq distributeExponent() =>
      Times(expressions.map((e) => e.distributeExponent()).toList());

  @override
  Eq simplifyDivisionOfAddition() =>
      Times(expressions.map((e) => e.simplifyDivisionOfAddition()).toList());

  @override
  Eq combineMultiplicationsAndPowers() {
    final (c, eq) = separateConstant();
    if (eq is! Times) {
      return eq.combineMultiplicationsAndPowers().withConstant(c);
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
        ret[i] = Power([ret[i], Constant(n.toDouble())]);
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
  Eq factorOutAddition() =>
      Times(expressions.map((e) => e.factorOutAddition()).toList());

  @override
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Times(expressions.map((e) => e.substitute(substitutions)).toList());

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

  // TODO only bracket when necessary
  @override
  String toString() {
    final numerators = <Eq>[];
    final denominators = <Eq>[];
    for (final e in expressions) {
      if (e is Power) {
        final div = e.toDivide;
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
      sb.write('(');
      sb.write(numerators.join('*'));
      sb.write(')');
    }

    if (denominators.isNotEmpty) {
      sb.write('/');
      if (Times(denominators).isLone &&
          Times(denominators).expressions.length == 1) {
        sb.write(denominators.join('*'));
      } else {
        sb.write('(');
        sb.write(denominators.join('*'));
        sb.write(')');
      }
    }
    return sb.toString();
  }

  @override
  bool get isLone {
    if (expressions.length == 1) {
      return expressions[0].isLone;
    }
    return expressions.every((e) => e.isLone);
  }
}
