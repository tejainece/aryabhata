import 'package:equation/equation.dart';
import 'package:number_factorization/number_factorization.dart';

class Plus extends Eq {
  final List<Eq> expressions;

  Plus._(this.expressions) : assert(expressions.isNotEmpty);

  factory Plus(List<Eq> expressions) {
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
  Plus expandPlus() {
    var terms =
        expressions
            .map((e) => e.simplify())
            .where((e) => e is! C || e.value != 0)
            .toList();
    var ret = <Eq>[];
    for (final term in terms) {
      if (term is Plus) {
        ret.addAll(term.expressions);
        continue;
      } else if (term is UnaryMinus) {
        final inside = term.expression;
        if (inside is Plus) {
          ret.addAll(
            inside.expressions.map((e) => UnaryMinus(e).simplify()).toList(),
          );
          continue;
        }
      }
      ret.add(term);
    }
    return Plus(ret);
  }

  @override
  Eq simplify() {
    final ret = expandPlus().expressions.toList();
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
      return ret[0].simplify();
    }

    return Plus(ret);
  }

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
      rightExps.add(UnaryMinus(e));
    }
    if (left.isEmpty) {
      return C(0);
    }
    if (left.length > 1) {
      throw UnimplementedError('Only linear equations are supported');
    }
    Eq right;
    if (rightExps.isEmpty) {
      right = C(0);
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
  (C, Eq) separateConstant() {
    final separated = expressions.map((e) => e.separateConstant()).toList();
    final constants = separated.map((e) => e.$1.value).toList();
    final gcd = gcdAll(constants);
    return (
      C(gcd),
      Plus(
        separated.map((e) => (C(e.$1.value / gcd) * e.$2).simplify()).toList(),
      ),
    );
  }

  @override
  Eq expandMultiplications() =>
      Plus(expressions.map((e) => e.expandMultiplications()).toList());

  @override
  Eq simplifyPowers() =>
      Plus(expressions.map((e) => e.simplifyPowers()).toList());

  @override
  Eq expandDivisions() =>
      Plus(expressions.map((e) => e.expandDivisions()).toList());

  @override
  Eq simplifyMultiplications() =>
      Plus(expressions.map((e) => e.simplifyMultiplications()).toList());

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write(expressions.first.toString());
    for (int i = 1; i < expressions.length; i++) {
      final (c, e) = expressions[i].separateConstant();
      if (c.value.isNegative) {
        sb.write(' - ');
      } else {
        sb.write(' + ');
      }
      bool hasC = false;
      if (c.value.abs() != 1) {
        sb.write(c.value.abs().stringMaybeInt);
        hasC = true;
      }
      if (!e.isSame(C(1))) {
        if (hasC) sb.write(' * ');
        sb.write(e);
      }
    }
    return sb.toString();
  }

  static Eq? _simplify(Eq f, Eq s) {
    if (f is C && s is C) {
      return C(f.value + s.value);
    }
    final u = Eq.tryAddTerms(f, s);
    if (u != null) {
      return u;
    }
    return null;
  }
}
