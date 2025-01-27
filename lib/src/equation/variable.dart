import 'package:equation/equation.dart';

class Variable extends Eq {
  final String name;

  const Variable._(this.name);

  factory Variable(String name) {
    validateName(name);
    return Variable._(name);
  }

  @override
  (double, Eq) separateConstant() => (1, this);

  @override
  bool isConstant() => false;

  @override
  Eq dissolveConstants({int? depth}) => this;

  @override
  Eq factorOutMinus({int? depth}) => this;

  @override
  Eq combineAddition() => this;

  @override
  double? toConstant() => null;

  @override
  Eq expandMultiplications({int? depth}) => this;

  @override
  Eq distributeExponent({int? depth}) => this;

  @override
  Eq dissolvePowerOfPower({int? depth}) => this;

  @override
  Eq expandDivision({int? depth}) => this;

  @override
  Eq combineMultiplications({int? depth}) => this;

  @override
  Eq combinePowers({int? depth}) => this;

  @override
  Eq factorOutAddition() => this;

  @override
  List<Eq> multiplicativeTerms() => [this];

  @override
  Eq dissolveMinus({int? depth}) => this;

  @override
  Eq dropMinus() => this;

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
  bool canDissolveConstants() => false;

  @override
  Simplification? canSimplify() => null;

  @override
  bool canDissolveMinus() => false;

  @override
  bool canCombineMultiplications() => false;

  @override
  bool canCombinePowers() => false;

  @override
  bool canDissolvePowerOfPower() => false;

  @override
  bool canDistributeExponent() => false;

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) => name;

  static void validateName(String name) {
    if (name.isEmpty) throw ArgumentError.notNull('cannot be empty');
    for (final char in [' ', '+', '-', '*', '/', '⋅', '(', ')']) {
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

const w = Variable._('w');

const x = Variable._('x');

const y = Variable._('y');

const z = Variable._('z');
