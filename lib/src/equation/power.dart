import 'dart:math';

import 'package:equation/equation.dart';

class Power extends Eq {
  final List<Eq> expressions;

  Power._(this.expressions) : assert(expressions.isNotEmpty);

  factory Power(Iterable<Eq> expressions) {
    var list = <Eq>[];
    for (final item in expressions) {
      if (item is Power) {
        list.addAll(item.expressions);
      } else {
        list.add(item);
      }
    }
    return Power._(list);
  }

  Eq get base => expressions.first;

  Eq get exponent =>
      expressions.length > 1
          ? Power(expressions.skip(1).toList())
          : Constant(1);

  @override
  Eq simplify() {
    var base = this.base.simplify();
    if (expressions.length == 1) {
      return base;
    }
    var exponent = this.exponent.simplify();

    final ec = exponent.toConstant();
    final bc = base.toConstant();
    if (ec != null) {
      if (ec == 0) {
        return Constant(1.0);
      } else if (ec == 1) {
        return base;
      }

      if (bc != null) {
        return Constant(pow(bc, ec).toDouble());
      }
    }
    if (bc != null) {
      if (bc == 1) {
        return Constant(1);
      }
    }
    return Power([base, exponent]);
  }

  @override
  Eq factorOutMinus() =>
      Power(expressions.map((e) => e.factorOutMinus()).toList());

  @override
  Eq dissolveMinus() =>
      Power(expressions.map((e) => e.dissolveMinus()).toList());

  @override
  Eq distributeMinus() =>
      Power(expressions.map((e) => e.distributeMinus()).toList());

  @override
  Eq combineAddition() =>
      Power(expressions.map((e) => e.combineAddition()).toList());

  @override
  Eq expandMultiplications() {
    if (expressions.length == 1) {
      return expressions[0].expandMultiplications();
    }
    if (expressions.length == 2) {
      Eq p = expressions[1];
      if (p is Constant && p.value >= 1 && p.value.isInt) {
        var ret = expressions[0];
        // TODO handle unary minus
        if (ret is Plus) {
          final exponent = p.value.round();
          for (int i = 1; i < exponent; i++) {
            ret = Times([ret, expressions[0]]).expandMultiplications();
          }
          return ret;
        } else if (ret is Times) {
          // TODO
        }
      }
    }
    return Power(expressions.map((e) => e.expandMultiplications()).toList());
  }

  @override
  Eq distributeExponent() {
    if (expressions.length == 1) {
      return this.base.distributeExponent();
    }
    var base = this.base;
    var exponent = this.exponent.distributeExponent();
    if (base is Times) {
      return Times(base.expressions.map((e) => Power([e, exponent])).toList());
    }
    return Power([base, exponent]);
  }

  @override
  Eq simplifyDivisionOfAddition() =>
      Power(expressions.map((e) => e.simplifyDivisionOfAddition()).toList());

  @override
  Eq combineMultiplicationsAndPowers() => Power(
    expressions.map((e) => e.combineMultiplicationsAndPowers()).toList(),
  );

  @override
  Eq factorOutAddition() =>
      Power(expressions.map((e) => e.factorOutAddition()).toList());

  @override
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Power(expressions.map((e) => e.substitute(substitutions)).toList());

  @override
  bool isSame(Eq otherSimplified, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    if (thisSimplified is! Power) {
      return thisSimplified.isSame(otherSimplified, epsilon);
    }
    otherSimplified = otherSimplified.simplify();
    if (otherSimplified is! Power) {
      // TODO handle UnaryMinus
      return false;
    }
    if (thisSimplified.expressions.length !=
        otherSimplified.expressions.length) {
      return false;
    }
    for (int i = 0; i < thisSimplified.expressions.length; i++) {
      if (!thisSimplified.expressions[i].isSame(
        otherSimplified.expressions[i],
        epsilon,
      )) {
        return false;
      }
    }
    return true;
  }

  Eq? get toDivide {
    if (expressions.length == 1) return null;
    final lastPow = expressions.last;
    if (lastPow.isSame(Constant(-1))) {
      if (expressions.length == 2) {
        return expressions[0];
      }
      return Power(expressions.sublist(0, expressions.length - 1));
    }
    final (c, eq) = lastPow.separateConstant();
    if (!c.isNegative) return null;
    return Power([
      ...expressions.sublist(0, expressions.length - 1),
      eq.withConstant(-c),
    ]);
  }

  // TODO only bracket when necessary
  @override
  String toString() {
    final parts = <String>[];
    for (final term in expressions) {
      if (term is Constant || term is Variable) {
        parts.add(term.toString());
        continue;
      }
      parts.add('(${term.toString()})');
    }
    return parts.join('**');
  }

  @override
  bool get isLone {
    if (expressions.length == 1) {
      return expressions[0].isLone;
    }
    return expressions.every((e) => e.isLone);
  }
}
