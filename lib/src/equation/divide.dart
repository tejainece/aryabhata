/*
import 'package:equation/equation.dart';

class Divide extends Eq {
  final List<Eq> expressions;

  Divide._(this.expressions) : assert(expressions.isNotEmpty);

  factory Divide(List<Eq> expressions) {
    final ret = <Eq>[];
    for (final e in expressions) {
      if (e is Divide) {
        ret.addAll(e.expressions);
      } else {
        ret.add(e);
      }
    }
    return Divide._(ret);
  }

  @override
  Eq simplify() {
    var ret = expressions.map((e) => e.simplify()).toList();
    var numerator = ret[0];
    if (ret.length == 1) {
      return numerator;
    }
    var denom = Times(ret.skip(1).toList()).simplify();
    var denomC = denom.toConstant();
    final numeratorC = numerator.toConstant();
    if (denomC != null) {
      if (denomC == 0) {
        return Constant(double.infinity);
      } else if (denomC == 1) {
        return numerator;
      }
      if (numeratorC != null) {
        return Constant(numeratorC / denomC);
      }
    }
    if (numerator.isSame(denom)) {
      return Constant(1);
    }
    // TODO handle unary minuses
    List<Eq> denominatorTerms;
    if (denom is Times) {
      denominatorTerms = denom.expressions.toList();
    } else {
      denominatorTerms = [denom];
    }
    if (numerator is Times) {
      final numeratorTerms = numerator.expressions.toList();
      for (int i = 0; i < denominatorTerms.length; i++) {
        final term = denominatorTerms[i];
        final match = numeratorTerms.indexWhere((e) => e.isSame(term));
        if (match == -1) {
          continue;
        }
        numeratorTerms.removeAt(match);
        denominatorTerms.removeAt(i);
        i--;
      }
      if (denominatorTerms.isEmpty ||
          Times(denominatorTerms).simplify().isSame(Constant(1))) {
        return Times(numeratorTerms).simplify();
      }
      if (numeratorTerms.isEmpty) {
        numeratorTerms.add(Constant(1));
      }
      return Divide([
        Times(numeratorTerms).simplify(),
        Times(denominatorTerms).simplify(),
      ]);
    }
    return Divide([numerator, denom]);
  }

  @override
  (Constant, Eq) separateConstant() {
    // TODO improve this
    return (Constant(1.0), this);
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
      return Minus(Divide._(ret));
    }
    return Divide._(ret);
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
      return Minus(Divide(ret));
    }
    return Divide(ret);
  }

  @override
  Eq distributeMinus() =>
      Divide(expressions.map((e) => e.distributeMinus()).toList());

  @override
  Eq combineAddition() =>
      Divide(expressions.map((e) => e.combineAddition()).toList());

  @override
  Eq expandMultiplications() =>
      Divide(expressions.map((e) => e.expandMultiplications()).toList());

  @override
  Eq distributeExponent() =>
      Divide(expressions.map((e) => e.distributeExponent()).toList());

  Eq get numerator => expressions.first;

  Eq get denominator =>
      expressions.length == 1
          ? Constant(1.0)
          : Times(expressions.skip(1).toList());

  @override
  Eq simplifyDivisionOfAddition() {
    final numerator = this.numerator.simplifyDivisionOfAddition();
    if (expressions.length == 1) {
      return numerator;
    }
    if (numerator is! Plus) {
      return this;
    }
    final denominator = this.denominator.simplifyDivisionOfAddition();
    final ret = <Eq>[];
    for (final part in numerator.expressions) {
      ret.add(Divide([part, denominator]));
    }
    return Plus(ret);
  }

  @override
  Eq combineMultiplicationsAndPowers() =>
      Divide(expressions.map((e) => e.combineMultiplicationsAndPowers()).toList());

  @override
  Eq factorOutAddition() =>
      Divide(expressions.map((e) => e.factorOutAddition()).toList());

  @override
  Eq substitute(Map<String, Eq> substitutions) =>
      Divide(expressions.map((e) => e.substitute(substitutions)).toList());

  @override
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  bool isSame(Eq otherSimplified, [double epsilon = 1e-6]) {
    final thisSimplified = simplify();
    otherSimplified = otherSimplified.simplify();
    if (thisSimplified is! Divide) {
      return thisSimplified.isSame(otherSimplified, epsilon);
    }
    otherSimplified = otherSimplified.simplify();
    if (otherSimplified is! Divide) {
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

  @override
  String toString() {
    final parts = <String>[];
    for (final e in expressions) {
      if (e is Value) {
        parts.add(e.toString());
        continue;
      } else if (e is Minus) {
        if (e.expression is Value) {
          parts.add('-${e.expression.toString()}');
          continue;
        }
        parts.add('-(${e.expression.toString()})');
        continue;
      }
      parts.add('(${e.toString()})');
    }
    return parts.join(' / ');
  }
}
 */
