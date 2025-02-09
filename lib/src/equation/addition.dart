import 'dart:collection';
import 'dart:math';

import 'package:equation/equation.dart';
import 'package:number_factorization/number_factorization.dart';

class Plus extends Eq {
  final UnmodifiableListView<Eq> expressions;

  Plus._(Iterable<Eq> expressions)
    : assert(expressions.isNotEmpty),
      expressions = UnmodifiableListView<Eq>(expressions.toList());

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
  Eq substitute(Map<String, Eq> substitutions) =>
      Plus(expressions.map((e) => e.substitute(substitutions)));

  @override
  Eq dissolveConstants({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final ret = <Eq>[];
    num constant = 0;
    for (var e in expressions) {
      e = e.dissolveConstants(depth: depth);
      final c = e.toConstant();
      if (c != null) {
        constant += c;
        continue;
      }
      ret.add(e);
    }
    if (ret.isEmpty) {
      return Constant(constant);
    } else if (!constant.isEqual(0)) {
      ret.insert(0, Eq.c(constant).dissolveMinus());
    }
    return Plus(ret);
  }

  @override
  num? toConstant() {
    num constant = 0;
    for (var e in expressions) {
      final c = e.toConstant();
      if (c == null) {
        return null;
      }
      constant += c;
    }
    return constant;
  }

  @override
  Eq factorOutMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list =
        expressions.map((e) => e.factorOutMinus(depth: depth)).toList();
    final count = list.fold(
      0,
      (int count, Eq v) => count + (v is Minus ? 1 : 0),
    );
    if (count > list.length / 2) {
      return Minus(
        Plus(
          list.map(
            (e) =>
                e is Minus
                    ? e.expression
                    : Minus(e).factorOutMinus(depth: depth),
          ),
        ),
      );
    }
    return Plus(list);
  }

  @override
  Eq dropMinus() => this;

  @override
  Eq dissolveMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    for (final e in expressions) {
      list.add(e.dissolveMinus(depth: depth));
    }
    /*final count = list.fold(
      0,
      (int count, Eq v) => count + (v is Minus ? 1 : 0),
    );
    if (count > list.length / 2) {
      return Minus(Plus(list.map((e) => e is Minus ? e.expression : Minus(e))));
    }*/
    return Plus(list);
  }

  @override
  Eq distributeMinus() => Plus(expressions.map((e) => e.distributeMinus()));

  @override
  Eq shrink({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final expressions = <Eq>[];
    for (Eq e in this.expressions) {
      e = e.shrink(depth: depth);
      if (e is Plus) {
        expressions.addAll(e.expressions);
        continue;
      }
      if (e is Minus && e.expression is Plus) {
        expressions.addAll(
          (e.expression as Plus).expressions.map((e) => Minus(e)),
        );
        continue;
      }
      expressions.add(e);
    }
    if (expressions.length == 1) {
      return expressions.first;
    }
    return Plus(expressions);
  }

  @override
  Eq combineAdditions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var ret = <Eq>[];
    for (var term in expressions) {
      ret.add(term.combineAdditions(depth: depth));
    }
    for (int i = 0; i < ret.length; i++) {
      for (int j = i + 1; j < ret.length; j++) {
        final s = tryAddTerms(ret[i], ret[j]);
        if (s != null) {
          ret[i] = s;
          ret.removeAt(j);
          j--;
          break;
        }
      }
    }
    return Plus(ret);
  }

  @override
  Times multiplicativeTerms() {
    List<Times> parts =
        expressions.map((e) => e.multiplicativeTerms()).toList();
    List<Eq> ret = parts.toList();
    final factors = <Eq>[];
    for (final possibles in parts) {
      if(possibles.isSame(one)) continue;
      for (var possible in possibles.expressions) {
        final object = tryFactorizeBy(possible, ret);
        if (object == null) continue;
        factors.add(possible);
        ret = object;
      }
    }
    if (factors.isEmpty) {
      return Times([this]);
    }
    return Times([...factors, Plus(ret)]);
  }

  @override
  Eq factorOutAddition() {
    final factors = <Eq>[];
    var ret = expressions.toList();
    final terms = expressions.first.multiplicativeTerms().expressions;
    for (final t in terms) {
      if (t is Constant && t.value.isInt) {
        int c = t.value.round().abs();
        middle:
        while (true) {
          final facs = integerFactorization(c).where((e) => e != 1);
          for (final f in facs) {
            final tmp = tryFactorizeBy(Eq.c(f.toDouble()), ret);
            if (tmp == null) continue;
            factors.add(Eq.c(f.toDouble()));
            ret = tmp;
            c = (c / f).round();
            continue middle;
          }
          break;
        }
        continue;
      }
      final tmp = tryFactorizeBy(t, ret);
      if (tmp == null) continue;
      factors.add(t);
      ret = tmp;
    }
    if (factors.isEmpty) {
      return this;
    }
    return Times([...factors, Plus(ret)]);
  }

  static List<Eq>? tryFactorizeBy(Eq factor, List<Eq> eq) {
    // assert(factor.isSingle);
    final ret = <Eq>[];
    for (int i = 0; i < eq.length; i++) {
      final d = eq[i].tryCancelDivision(factor);
      if (d == null) return null;
      ret.add(d);
    }
    return ret;
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
  (num, Plus) separateConstant() {
    final separated = expressions.map((e) => e.separateConstant()).toList();
    final constants = separated.map((e) => e.$1).toList();
    num gcd = gcdAll(constants.map((e) => e.abs()));
    // Separate sign
    final numNeg = constants.fold(0, (int v, num c) => c.isNegative ? ++v : v);
    if (numNeg > constants.length / 2) {
      gcd = -gcd;
    }
    return (
      gcd,
      Plus(
        separated.map((e) {
          final c = e.$1 / gcd;
          if (c.isEqual(1)) return e.$2;
          return (Constant(c) * e.$2).dissolveMinus(depth: 1);
        }),
      ),
    );
  }

  @override
  Eq expandMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Plus(expressions.map((e) => e.expandMultiplications(depth: depth)));
  }

  @override
  Eq expandPowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    for (final e in expressions) {
      list.add(e.expandPowers(depth: depth));
    }
    return Plus(list);
  }

  @override
  Eq distributeExponent({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Plus(expressions.map((e) => e.distributeExponent(depth: depth)));
  }

  @override
  Eq expandDivision({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Plus(expressions.map((e) => e.expandDivision(depth: depth)));
  }

  @override
  Eq combineMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    for (final e in expressions) {
      list.add(e.combineMultiplications(depth: depth));
    }
    return Plus(list);
  }

  @override
  Eq combinePowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    for (final e in expressions) {
      list.add(e.combinePowers(depth: depth));
    }
    return Plus(list);
  }

  @override
  Eq dissolvePowerOfPower({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    for (final e in expressions) {
      list.add(e.dissolvePowerOfPower(depth: depth));
    }
    return Plus(list);
  }

  @override
  Eq? tryCancelDivision(Eq other) {
    if (isSame(other)) return one;
    if (isSame(Minus(other))) return -one;
    final ret = tryFactorizeBy(other, expressions);
    if (ret == null) {
      return null;
    }
    return Plus(ret);
  }

  @override
  Eq reduceDivisions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    for (final e in expressions) {
      list.add(e.reduceDivisions(depth: depth));
    }
    return Plus(list);
  }

  @override
  bool get isSingle => false;

  @override
  bool get isLone {
    if (expressions.length != 1) return false;
    return expressions[0].isLone;
  }

  @override
  Simplification? canSimplify() {
    if (canShrink()) return Simplification.shrink;
    for (final e in expressions) {
      final s = e.canSimplify();
      if (s != null) return s;
    }
    if (canDissolveConstants()) return Simplification.dissolveConstants;
    if (canCombineAdditions()) return Simplification.combineAdditions;
    return null;
  }

  @override
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  bool isSame(Eq otherSimplified, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    otherSimplified = otherSimplified.simplify();
    if (thisSimplified is! Plus) {
      return thisSimplified.isSame(otherSimplified, epsilon);
    }
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
  bool canDissolveConstants() {
    if (expressions.length == 1) return expressions.first.toConstant() != null;
    int countConstants = 0;
    for (final e in expressions) {
      if (e.canDissolveConstants()) return true;
      final c = e.toConstant();
      if (c == null) continue;
      if (c.isEqual(0)) return true;
      if (e.toConstant() != null) countConstants++;
    }
    return countConstants > 1;
  }

  @override
  bool canDissolveMinus() {
    /*int countMinus = 0;
    for (final e in expressions) {
      if (e.canDissolveMinus()) return true;
      if (e is Minus) countMinus++;
    }
    return countMinus > expressions.length / 2;*/
    return expressions.any((e) => e.canDissolveMinus());
  }

  @override
  bool canShrink() {
    for (final e in expressions) {
      if (e.canShrink()) return true;
      if (e is Plus) return true;
      if (e is Minus && e.expression is Plus) return true;
    }
    return expressions.length == 1;
  }

  @override
  bool canFactorOutAddition() {
    throw UnimplementedError();
    // TODO
    return false;
  }

  @override
  bool canCombineAdditions() {
    for (final e in expressions) {
      if (e.canCombineAdditions()) return true;
    }
    for (int i = 0; i < expressions.length; i++) {
      for (int j = i + 1; j < expressions.length; j++) {
        if (canAddTerms(expressions[i], expressions[j])) return true;
      }
    }
    return false;
  }

  @override
  bool canCombineMultiplications() =>
      expressions.any((e) => e.canCombineMultiplications());

  @override
  bool canExpandMultiplications() =>
      expressions.any((e) => e.canExpandMultiplications());

  @override
  bool canReduceDivisions() => expressions.any((e) => e.canReduceDivisions());

  @override
  bool canCombinePowers() => expressions.any((e) => e.canCombinePowers());

  @override
  bool canExpandPowers() => expressions.any((e) => e.canExpandPowers());

  @override
  bool canDissolvePowerOfPower() {
    for (final e in expressions) {
      if (e.canDissolvePowerOfPower()) return true;
    }
    return false;
  }

  @override
  bool canDistributeExponent() {
    for (final e in expressions) {
      if (e.canDistributeExponent()) return true;
    }
    return false;
  }

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) {
    final sb = StringBuffer();
    sb.write(expressions.first.toString(spec: spec));
    for (int i = 1; i < expressions.length; i++) {
      var (c, e) = expressions[i].separateConstant();
      if (c.isNegative) {
        sb.write(spec.minus);
      } else {
        sb.write(spec.plus);
      }
      c = c.abs();
      bool hasC = false;
      if ((c - 1).abs() > 1e-6) {
        sb.write(c.stringMaybeInt);
        hasC = true;
      }
      if (!(e.toConstant()?.isEqual(1) ?? false) || !hasC) {
        if (hasC) sb.write(spec.times);
        if (e.isLone) {
          sb.write(e.toString(spec: spec));
        } else {
          sb.write(spec.lparen);
          sb.write(e.toString(spec: spec));
          sb.write(spec.rparen);
        }
      }
    }
    return sb.toString();
  }

  static bool canAddTerms(Eq a, Eq b) {
    var (aC, aSimplified) = a.separateConstant();
    var (bC, bSimplified) = b.separateConstant();
    return aSimplified.isSame(bSimplified);
  }

  static Eq? tryAddTerms(Eq a, Eq b) {
    var (aC, aSimplified) = a.separateConstant();
    var (bC, bSimplified) = b.separateConstant();
    if (!aSimplified.isSame(bSimplified)) return null;

    if (aSimplified is Constant) {
      return Constant((aC + bC) * aSimplified.value).dissolveMinus();
    }
    return aSimplified.withConstant(aC + bC);
  }
}
