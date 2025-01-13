import 'package:equation/equation.dart';

class Times extends Eq {
  final List<Eq> expressions;

  Times._(this.expressions) : assert(expressions.isNotEmpty);

  factory Times(List<Eq> expressions) {
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
  Eq substitute(Map<String, Eq> substitutions) {
    return Times(expressions.map((e) => e.substitute(substitutions)).toList());
  }

  @override
  Eq simplify() {
    double c = 1;
    final denom = <Eq>[];
    final ret = <Eq>[];
    for (final e in expressions) {
      var s = e.simplify();
      if (s is C) {
        if (s.value == 0.0) {
          return C(0.0);
        } else if (s.value == 1.0) {
          continue;
        }
        c *= s.value;
        continue;
      }
      final (tc, ts) = s.separateConstant();
      c *= tc.value;
      if (ts is Times) {
        ret.addAll(ts.expressions);
      } else if (ts is Divide) {
        denom.add(ts.denominator);
        final numerator = ts.numerator;
        if (numerator is Times) {
          ret.addAll(numerator.expressions);
        } else {
          ret.add(numerator);
        }
      } else if(ts is C) {
        c *= ts.value;
      } else {
        ret.add(ts);
      }
    }
    // Detect powers
    // TODO detect real powers, hidden powers
    for (int i = 0; i < ret.length; i++) {
      int n = 1;
      for (int j = i + 1; j < ret.length; j++) {
        if (!ret[i].isSame(ret[j])) {
          continue;
        }
        n++;
        ret.removeAt(j);
        j--;
      }
      if (n > 1) {
        ret[i] = Power([ret[i], C(n.toDouble())]);
      }
    }
    Eq numerator;
    if (ret.isEmpty) {
      numerator = C(c);
    } else {
      if ((c - 1).abs() > 1e-6) {
        ret.insert(0, C(c));
      }
      if (ret.length == 1) {
        numerator = ret[0];
      } else {
        numerator = Times(ret);
      }
    }
    if (denom.isEmpty) {
      return numerator;
    }
    return Divide([numerator, Times._(denom)]).simplify();
  }

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
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  (C, Eq) separateConstant() {
    C c = C(1.0);
    final ret = <Eq>[];
    for (final e in expressions) {
      if (e is C) {
        c = C(c.value * e.value);
        continue;
      } else if (e is UnaryMinus) {
        final exp = e.expression;
        if (exp is C) {
          c = C(c.value * -exp.value);
          continue;
        }
        c = C(c.value * -1.0);
        ret.add(exp);
        continue;
      }
      ret.add(e);
    }
    if (ret.isEmpty) {
      return (c, C(1.0));
    } else if (ret.length == 1) {
      return (c, ret[0]);
    }
    return (c, Times._(ret));
  }

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
  Eq simplifyPowers() =>
      Times(expressions.map((e) => e.simplifyPowers()).toList());

  @override
  Eq expandDivisions() =>
      Times(expressions.map((e) => e.expandDivisions()).toList());

  @override
  Eq simplifyMultiplications() {
    // TODO
    return this;
  }

  // TODO only bracket when necessary
  @override
  String toString() {
    final parts = <String>[];
    for (final e in expressions) {
      if (e is Value || e is Trig) {
        parts.add(e.toString());
        continue;
      } else if (e is UnaryMinus) {
        if (e.expression is Value || e.expression is Trig) {
          parts.add('-${e.expression}');
          continue;
        }
        parts.add('-(${e.expression.toString()})');
        continue;
      }
      parts.add('(${e.toString()})');
    }
    return parts.join(' * ');
  }
}
