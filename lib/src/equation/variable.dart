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
  (double, Eq) separateConstant() => (1, this);

  @override
  bool isConstant() => false;

  @override
  Eq factorOutMinus() => this;

  @override
  Eq combineAddition() => this;

  @override
  double? toConstant() => null;

  @override
  Eq expandMultiplications({int? depth}) => this;

  @override
  Eq distributeExponent({int? depth}) => this;

  @override
  Eq simplifyDivisionOfAddition({int? depth}) => this;

  @override
  Eq combineMultiplications({int? depth}) => this;

  @override
  Eq combinePowers({int? depth}) => this;

  @override
  Eq factorOutAddition() => this;

  @override
  List<Eq> multiplicativeTerms() => [this];

  @override
  Eq dissolveMinus() => this;

  @override
  Eq distributeMinus() => this;

  @override
  Eq? tryCancelDivision(Eq other) {
    assert(other.isSingle);
    if (other is! Variable) return null;
    return other.name == name ? Constant(1.0) : null;
  }

  @override
  bool get isLone => true;

  @override
  bool get isSingle => true;

  @override
  bool hasVariable(Variable v) => v.name == name;

  @override
  Eq substitute(Map<String, Eq> substitutions) => substitutions[name] ?? this;

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
