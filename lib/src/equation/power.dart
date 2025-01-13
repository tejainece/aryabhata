import 'dart:math';
import 'package:equation/equation.dart';

class Power extends Eq {
  final List<Eq> expressions;

  Power._(this.expressions) : assert(expressions.isNotEmpty);

  factory Power(List<Eq> expressions) {
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
      expressions.length > 1 ? Power(expressions.skip(1).toList()) : C(1);

  @override
  Eq substitute(Map<String, Eq> substitutions) {
    return Power(expressions.map((e) => e.substitute(substitutions)).toList());
  }

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
        return C(1.0);
      } else if (ec == 1) {
        return base;
      }

      if (bc != null) {
        return C(pow(bc, ec).toDouble());
      }
    }
    if (bc != null) {
      if (bc == 1) {
        return C(1);
      }
    }
    return Power([base, exponent]);
  }

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

  @override
  bool hasVariable(Variable v) => expressions.any((e) => e.hasVariable(v));

  @override
  Eq expandMultiplications() {
    if (expressions.length == 1) {
      return expressions[0].expandMultiplications();
    }
    if (expressions.length == 2) {
      Eq p = expressions[1];
      if (p is C && p.value > 1 && p.value.isInt) {
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
  Eq simplifyPowers() {
    if (expressions.length == 1) {
      return this.base.simplifyPowers();
    }
    var base = this.base;
    var exponent = this.exponent.simplifyPowers();
    if (base is Divide) {
      return Divide(base.expressions.map((e) => Power([e, exponent])).toList());
    } else if (base is Times) {
      return Times(base.expressions.map((e) => Power([e, exponent])).toList());
    }
    return Power([base, exponent]);
  }

  @override
  Eq expandDivisions() =>
      Power(expressions.map((e) => e.expandDivisions()).toList());

  @override
  Eq simplifyMultiplications() =>
      Power(expressions.map((e) => e.simplifyMultiplications()).toList());

  // TODO only bracket when necessary
  @override
  String toString() {
    final parts = <String>[];
    for (final term in expressions) {
      if (term is C || term is Variable) {
        parts.add(term.toString());
        continue;
      }
      parts.add('(${term.toString()})');
    }
    return parts.join(' ** ');
  }
}
