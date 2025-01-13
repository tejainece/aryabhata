import 'package:equation/equation.dart';

class Variable extends Eq implements Value {
  final String name;

  const Variable._(this.name);

  factory Variable(String name) {
    validateName(name);
    return Variable._(name);
  }

  @override
  Eq substitute(Map<String, Eq> substitutions) {
    return substitutions[name] ?? this;
  }

  @override
  Eq simplify() => this;

  @override
  bool isSame(Eq other, [double epsilon = 1e-6]) =>
      other is Variable && other.name == name;

  @override
  bool isConstant() => false;

  @override
  double? toConstant() => null;

  @override
  bool hasVariable(Variable v) => v.name == name;

  @override
  Eq expandMultiplications() => this;

  @override
  Eq simplifyPowers() => this;

  @override
  Eq expandDivisions() => this;

  @override
  Eq simplifyMultiplications() => this;

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