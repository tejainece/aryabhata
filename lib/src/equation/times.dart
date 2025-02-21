import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equation/equation.dart';

class Times extends Eq {
  final UnmodifiableListView<Eq> expressions;

  Times._(Iterable<Eq> expressions)
    : assert(expressions.isNotEmpty),
      expressions = UnmodifiableListView<Eq>(expressions);

  factory Times(Iterable<Eq> expressions) {
    final ret = <Eq>[];
    for (final e in expressions) {
      if (e is Times) {
        for (final t in e.expressions) {
          if (t.toConstant()?.isEqual(1) ?? false) continue;
          ret.add(t);
        }
      } else if (e.toConstant()?.isEqual(1) ?? false) {
        continue;
      } else {
        ret.add(e);
      }
    }
    if (ret.isEmpty) {
      ret.add(one);
    }
    return Times._(ret);
  }

  factory Times.fromJson(Map map) {
    assert(map['type'] == EqJsonType.times.name);
    final List expressions = map['expressions'];
    return Times(expressions.map((e) => Eq.from(e)).toList());
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
  num? toConstant() {
    num constant = 1;
    for (var e in expressions) {
      final c = e.toConstant();
      if (c == null) {
        return null;
      }
      constant *= c;
    }
    return constant;
  }

  @override
  Eq dissolveConstants({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    for (Eq e in expressions) {
      e = e.dissolveConstants(depth: depth);
      final terms = e.multiplicativeTerms().expressions;
      list.addAll(terms);
    }
    num constant = 1;
    final ret = <Eq>[];
    for (var e in list) {
      final c = e.toConstant();
      if (c != null) {
        constant *= c;
        continue;
      }
      ret.add(e);
    }
    if (constant.isNaN || constant.isInfinite || constant.isEqual(0)) {
      return Constant(constant);
    }
    // TODO try to keep constants integers
    if (ret.isEmpty) {
      return Constant(constant);
    } else if (!constant.isEqual(1)) {
      ret.insert(0, Eq.c(constant).dissolveMinus());
    }
    return Times(ret);
  }

  @override
  Eq dissolveMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    bool isMinus = false;
    final ret = <Eq>[];
    for (var e in expressions) {
      e = e.dissolveMinus(depth: depth);
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
  Eq dropMinus() => this;

  @override
  Eq factorOutMinus({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final ret = expressions.map((e) => e.factorOutMinus(depth: depth)).toList();
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
  Eq shrink({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final expressions = this.expressions.map((e) => e.shrink(depth: depth));
    if (expressions.length == 1) {
      return expressions.first;
    }
    return Times(expressions);
  }

  @override
  bool canShrink() {
    for (final e in expressions) {
      if (e.canShrink()) return true;
    }
    return expressions.length == 1;
  }

  @override
  Eq combineAdditions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Times(expressions.map((e) => e.combineAdditions(depth: depth)));
  }

  /// (x + 5) * (x + 8) = x^2 + 13x + 40
  @override
  Eq expandMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    bool minus = false;
    for (var e in expressions) {
      e = e.expandMultiplications(depth: depth).dissolveMinus(depth: 1);
      if (e is Minus) {
        e = e.expression;
        minus = !minus;
      }
      if (e is Times) {
        list.addAll(e.expressions);
      } else {
        list.add(e);
      }
    }
    Plus ret = Plus([list.first]);
    for (final e in list.skip(1)) {
      ret = ret.expandingMultiply(e);
    }
    if (ret.expressions.length == 1) {
      if (minus) {
        return Minus(ret.expressions.first);
      }
      return ret.expressions.first;
    }
    if (minus) {
      return Minus(ret);
    }
    return ret;
  }

  @override
  Eq expandDivision({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var (numerators, denominators) = separateDivision();
    if (denominators.isEmpty) {
      return Times(expressions.map((e) => e.expandDivision(depth: depth)));
    }
    denominators = denominators.map((e) => Power(e, -one)).toList();
    final list = <Eq>[];
    bool done = false;
    for (var n in numerators) {
      if (done) {
        list.add(n);
        continue;
      }
      if (n is Plus) {
        list.add(Plus(n.expressions.map((e) => Times([e, ...denominators]))));
        done = true;
        continue;
      }
      var tmp = n.dissolveMinus(depth: 1);
      if (tmp is Minus) {
        tmp = tmp.expression;
        if (tmp is Plus) {
          for (final term in tmp.expressions) {
            list.add(Minus(Times([term, ...denominators])));
          }
          done = true;
          continue;
        }
      }
      list.add(n);
    }
    return Times(expressions.map((e) => e.expandDivision(depth: depth)));
  }

  @override
  Times distributeExponent({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Times(expressions.map((e) => e.distributeExponent(depth: depth)));
  }

  @override
  Eq dissolvePowerOfPower({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    return Times(expressions.map((e) => e.dissolvePowerOfPower(depth: depth)));
  }

  @override
  Eq combineMultiplications({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    var (c, eq) = separateConstant();
    if (eq is! Times) {
      return eq.combineMultiplications(depth: depth).withConstant(c);
    }
    final ret = <Eq>[];
    for (var e in eq.expressions) {
      ret.add(e.combineMultiplications(depth: depth));
    }

    for (int i = 0; i < ret.length; i++) {
      for (int j = i + 1; j < ret.length; j++) {
        Eq a = ret[i];
        Eq b = ret[j];
        final tmp = tryCombineMultiplicativeTerms(a, b);
        if (tmp == null) continue;
        ret[i] = tmp;
        ret.removeAt(j);
        j--;
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
      if (depth < 0) return this;
    }
    final ret = <Eq>[];
    bool isMinus = false;
    for (var exp in expressions) {
      exp = exp.combinePowers(depth: depth).dissolveMinus(depth: 1);
      if (exp is Minus) {
        isMinus = !isMinus;
        exp = exp.expression;
      }
      if (exp is Times) {
        ret.addAll(exp.expressions);
      } else {
        ret.add(exp);
      }
    }
    if (isMinus) {
      ret.insert(0, Minus(one));
    }
    outer:
    for (int i = 0; i < ret.length; i++) {
      final a = ret[i];
      if (a is! Power) continue;
      for (int j = i + 1; j < ret.length; j++) {
        final b = ret[j];
        if (b is! Power) continue;
        final res = Power.tryCombinePower(a, b);
        if (res == null) continue;
        ret[i] = res;
        ret.removeAt(j);
        i--;
        continue outer;
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
  Eq expandPowers({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    final list = <Eq>[];
    for (final e in expressions) {
      list.add(e.expandPowers(depth: depth));
    }
    return Times(list);
  }

  @override
  Eq factorOutAddition() =>
      Times(expressions.map((e) => e.factorOutAddition()));

  @override
  Times multiplicativeTerms() {
    final ret = <Eq>[];
    for (var e in expressions) {
      ret.add(e.multiplicativeTerms());
    }
    return Times(ret);
  }

  @override
  Eq? tryCancelDivision(Eq other) {
    final ret = <Eq>[];
    bool found = false;
    for (final e in expressions) {
      if (found) {
        ret.add(e);
        continue;
      }
      final div = e.tryCancelDivision(other);
      if (div == null) {
        ret.add(e);
        continue;
      }
      ret.add(div);
      found = true;
    }
    if(!found) return null;
    if(ret.length == 1) return ret.first;
    return Times(ret);
    /*
    final ret = multiplicativeTerms().expressions.toList();
    for (int i = 0; i < ret.length; i++) {
      final v = ret[i];
      final d = v.tryCancelDivision(other);
      if (d == null) continue;
      if (!d.isSame(one)) {
        ret[i] = d;
      } else {
        ret.removeAt(i);
      }
      if (ret.length == 1) return ret.first;
      return Times(ret);
    }
    return null;
     */
  }

  @override
  Eq reduceDivisions({int? depth}) {
    if (depth != null) {
      depth = depth - 1;
      if (depth < 0) return this;
    }
    if (!canReduceDivisions()) return this;
    final parts = <Eq>[];
    for (var e in expressions) {
      parts.addAll(
        e.reduceDivisions(depth: depth).multiplicativeTerms().expressions,
      );
    }
    var reduced =
        Times(parts).combineMultiplications(depth: 1).dissolveConstants();
    return reduced;
  }

  @override
  bool get isSingle => false;

  @override
  bool get isLone {
    if (expressions.length == 1) {
      return expressions[0].isLone;
    }
    return expressions.every((e) => e.isLone);
    // return false;
  }

  @override
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Times(expressions.map((e) => e.substitute(substitutions)));

  @override
  bool isSame(Eq otherSimplified, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    otherSimplified = otherSimplified.simplify();
    if (thisSimplified is! Times) {
      return thisSimplified.isSame(otherSimplified, epsilon);
    }
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

  (List<Eq>, List<Eq>) separateDivision() {
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

    return (numerators, denominators);
  }

  @override
  bool canDissolveConstants() {
    int countConstants = 0;
    for (int i = 0; i < expressions.length; i++) {
      final e = expressions[i];
      if (e.canDissolveConstants()) return true;
      for (final term in e.multiplicativeTerms().expressions) {
        final c = term.toConstant();
        if (c == null) continue;
        if (i != 0) return true;
        if (c.isEqual(1)) return true;
        countConstants++;
        if (countConstants > 1) return true;
      }
    }
    return false;
  }

  @override
  bool canDissolveMinus() {
    for (final e in expressions) {
      if (e.canDissolveMinus()) return true;
      if (e is Minus) return true;
    }
    return false;
  }

  @override
  bool canFactorOutAddition() {
    for (final e in expressions) {
      if (e.canFactorOutAddition()) {
        return true;
      }
    }
    return false;
  }

  @override
  bool canCombineAdditions() {
    for (final e in expressions) {
      if (e.canCombineAdditions()) {
        return true;
      }
    }
    return false;
  }

  @override
  bool canCombineMultiplications() {
    for (final e in expressions) {
      if (e.canCombineMultiplications()) return true;
    }
    for (int i = 0; i < expressions.length; i++) {
      final a = expressions[i];
      for (int j = i + 1; j < expressions.length; j++) {
        final b = expressions[j];
        final tmp = tryCombineMultiplicativeTerms(a, b);
        if (tmp != null) return true;
      }
    }
    return false;
  }

  @override
  bool canExpandMultiplications() {
    final list = <Eq>[];
    for (var e in expressions) {
      e = e.expandMultiplications().dissolveMinus(depth: 1);
      if (e is Minus) {
        e = e.expression;
      }
      if (e is Times) {
        list.addAll(e.expressions);
      } else {
        list.add(e);
      }
    }
    if (list.length < 2) return false;
    return list.any((e) => e is Plus);
  }

  @override
  bool canReduceDivisions() {
    final parts = <Eq>[];
    for (var e in expressions) {
      if (e.canReduceDivisions()) return true;
      parts.addAll(e.multiplicativeTerms().expressions);
    }
    /*if (Times(parts).canCombineMultiplications()) {
      return true;
    }
    if (Times(parts).canDissolveConstants()) {
      return true;
    }*/
    return false;
  }

  @override
  bool canCombinePowers() {
    final ret = <Eq>[];
    bool isMinus = false;
    for (var exp in expressions) {
      if (exp.canCombinePowers()) return true;
      exp = exp.dissolveMinus(depth: 1);
      if (exp is Minus) {
        isMinus = !isMinus;
        exp = exp.expression;
      }
      if (exp is Times) {
        ret.addAll(exp.expressions);
      } else {
        ret.add(exp);
      }
    }
    if (isMinus) {
      ret.insert(0, Minus(one));
    }
    for (int i = 0; i < ret.length; i++) {
      final a = ret[i];
      if (a is! Power) continue;
      for (int j = i + 1; j < ret.length; j++) {
        final b = ret[j];
        if (b is! Power) continue;
        if (Power.canCombinePower(a, b)) return true;
      }
    }
    return false;
  }

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
  Simplification? canSimplify() {
    if (canShrink()) return Simplification.shrink;
    for (final e in expressions) {
      final s = e.canSimplify();
      if (s != null) return s;
    }
    if (canDissolveConstants()) return Simplification.dissolveConstants;
    if (canDissolveMinus()) return Simplification.dissolveMinus;
    if (canCombineMultiplications()) {
      return Simplification.combineMultiplications;
    }
    if (canExpandMultiplications()) return Simplification.expandMultiplications;
    if (canReduceDivisions()) return Simplification.reduceDivisions;
    return null;
  }

  /*
  @override
  Eq simplify() {
    Eq ret = Times(expressions.map((e) => e.simplify()));
    ret = ret.combinePowers();
    ret = ret.distributeExponent();
    ret = ret.dissolvePowerOfPower();
    ret = ret.combineMultiplications();
    return ret;
  }
   */

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) {
    final (numerators, denominators) = separateDivision();
    final sb = StringBuffer();
    if (numerators.isNotEmpty) {
      for (int i = 0; i < numerators.length; i++) {
        final n = numerators[i];
        if (n.isLone) {
          sb.write(n.toString(spec: spec));
        } else {
          sb.write(spec.lparen);
          sb.write(n.toString(spec: spec));
          sb.write(spec.rparen);
        }
        if (i < numerators.length - 1) {
          sb.write(spec.times);
        }
      }
    } else {
      sb.write('1');
    }
    if (denominators.isNotEmpty) {
      sb.write(spec.divide);
      final first = denominators.first;
      if (denominators.length == 1 && first.isSingle) {
        if(first.isSingle) {
          sb.write(first.toString(spec: spec));
        } else {
          sb.write(spec.lparen);
          sb.write(first.toString(spec: spec));
          sb.write(spec.rparen);
        }
      } else {
        final tmp = Times(denominators);
        sb.write(spec.lparen);
        sb.write(tmp.toString(spec: spec));
        /*for (int i = 0; i < denominators.length; i++) {
          final d = denominators[i];
          if (d is! Times) {
            sb.write(d.toString(spec: spec));
          } else {
            sb.write(d.toString(spec: spec));
          }
          if (i < denominators.length - 1) {
            sb.write(spec.times);
          }
        }*/
        sb.write(spec.rparen);
      }
    }
    return sb.toString();
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': EqJsonType.times.name,
    'expressions': expressions.map((e) => e.toJson()).toList(),
  };

  @override
  int get hashCode => Object.hashAllUnordered(expressions);

  @override
  bool operator ==(Object other) {
    if (other is! Times) return false;
    return DeepCollectionEquality.unordered().equals(
      expressions,
      other.expressions,
    );
  }

  static Eq? tryCombineMultiplicativeTerms(Eq a, Eq b) {
    Eq aBase, aExponent, bBase, bExponent;
    if (a is Power) {
      aBase = a.base;
      aExponent = a.exponent;
    } else {
      aBase = a;
      aExponent = one;
    }
    if (b is Power) {
      bBase = b.base;
      bExponent = b.exponent;
    } else {
      bBase = b;
      bExponent = one;
    }
    if (aBase.isSame(bBase)) {
      return Power(aBase, aExponent + bExponent);
    }
    return null;
  }
}
