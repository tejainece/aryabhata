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
  Eq substitute(Map<String, Eq> substitutions) {
    return Divide(expressions.map((e) => e.substitute(substitutions)).toList());
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
        return C(double.infinity);
      } else if (denomC == 1) {
        return numerator;
      }
      if (numeratorC != null) {
        return C(numeratorC / denomC);
      }
    }
    if (numerator.isSame(denom)) {
      return C(1);
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
          Times(denominatorTerms).simplify().isSame(C(1))) {
        return Times(numeratorTerms).simplify();
      }
      if (numeratorTerms.isEmpty) {
        numeratorTerms.add(C(1));
      }
      return Divide([
        Times(numeratorTerms).simplify(),
        Times(denominatorTerms).simplify(),
      ]);
    }
    return Divide([numerator, denom]);
  }

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
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  (C, Eq) separateConstant() {
    // TODO improve this
    return (C(1.0), this);
  }

  @override
  Eq expandMultiplications() =>
      Divide(expressions.map((e) => e.expandMultiplications()).toList());

  @override
  Eq simplifyPowers() =>
      Divide(expressions.map((e) => e.simplifyPowers()).toList());

  Eq get numerator => expressions.first;

  Eq get denominator =>
      expressions.length == 1 ? C(1.0) : Times(expressions.skip(1).toList());

  @override
  Eq expandDivisions() {
    final numerator = this.numerator.expandDivisions();
    if (expressions.length == 1) {
      return numerator;
    }
    if (numerator is! Plus) {
      return this;
    }
    final denominator = this.denominator.expandDivisions();
    final ret = <Eq>[];
    for (final part in numerator.expressions) {
      ret.add(Divide([part, denominator]));
    }
    return Plus(ret);
  }

  @override
  Eq simplifyMultiplications() =>
      Divide(expressions.map((e) => e.simplifyMultiplications()).toList());

  @override
  String toString() {
    final parts = <String>[];
    for (final e in expressions) {
      if (e is Value) {
        parts.add(e.toString());
        continue;
      } else if (e is UnaryMinus) {
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
