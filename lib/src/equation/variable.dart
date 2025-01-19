import 'package:equation/equation.dart';

class Variable extends Eq implements Value {
  final String name;

  const Variable._(this.name);

  factory Variable(String name) {
    validateName(name);
    return Variable._(name);
  }

  @override
  Eq simplify() => this;

  @override
  bool isConstant() => false;

  @override
  Eq factorOutMinus() => this;

  @override
  Eq combineAddition() => this;

  @override
  double? toConstant() => null;

  @override
  Eq expandMultiplications() => this;

  @override
  Eq distributeExponent() => this;

  @override
  Eq simplifyDivisionOfAddition() => this;

  @override
  Eq combineMultiplicationsAndPowers() => this;

  @override
  Eq factorOutAddition() => this;

  @override
  bool hasVariable(Variable v) => v.name == name;

  @override
  Eq substitute(Map<String, Eq> substitutions) {
    return substitutions[name] ?? this;
  }

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) =>
      other is Variable && other.name == name;

  @override
  String toString() => name;

  static void validateName(String name) {
    if (name.isEmpty) throw ArgumentError.notNull('cannot be empty');
    for (final char in [' ', '+', '-', '*', '/', '*', '(', ')']) {
      if (name.contains(char)) {
        throw ArgumentError('variable name cannot contain "$char"');
      }
    }
  }

  @override
  Eq dissolveMinus() => this;

  @override
  Eq distributeMinus() => this;

  @override
  bool get isLone => true;
}

const a = Variable._('a');

const b = Variable._('b');

const c = Variable._('c');

const d = Variable._('d');

const h = Variable._('h');

const k = Variable._('k');

const l = Variable._('l');

const m = Variable._('m');

const n = Variable._('n');

const r = Variable._('r');

const x = Variable._('x');

const y = Variable._('y');

const z = Variable._('z');
