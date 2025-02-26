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
  Eq dissolveImaginary() => this;

  @override
  Eq shrink({int? depth}) => this;

  @override
  Eq combineAdditions({int? depth}) => this;

  @override
  double? toConstant() => null;

  @override
  Eq expandMultiplications({int? depth}) => this;

  @override
  Eq distributeExponent({int? depth}) => this;

  @override
  Eq dissolvePowerOfPower({int? depth}) => this;

  @override
  Eq dissolvePowerOfComplex({int? depth}) => this;

  @override
  Eq rationalizeComplexDenominator() => this;

  @override
  Eq expandDivision({int? depth}) => this;

  @override
  Eq combineMultiplications({int? depth}) => this;

  @override
  Eq combinePowers({int? depth}) => this;

  @override
  Eq expandPowers({int? depth}) => this;

  @override
  Eq factorOutAddition() => this;

  @override
  Times multiplicativeTerms() => Times([this]);

  @override
  (List<Eq> numerators, List<Eq> denominators) separateDivision() => (
    [this],
    [],
  );

  @override
  Eq dissolveMinus({int? depth}) => this;

  @override
  Eq dropMinus() => this;

  @override
  Eq distributeMinus() => this;

  @override
  Eq reduceDivisions({int? depth}) => this;

  @override
  Eq? tryCancelDivision(Eq other) {
    if (other is! Variable || other.name != name) return null;
    return Constant(1.0);
  }

  @override
  bool needsParenthesis({bool noMinus = false}) => false;

  @override
  bool isSimpleConstant() => false;

  @override
  bool get isSingle => true;

  @override
  bool get isNegative => false;

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
  bool canShrink() => false;

  @override
  bool canCombineAdditions() => false;

  @override
  bool canDissolveMinus() => false;

  @override
  bool canDissolveImaginary() => false;

  @override
  bool canFactorOutAddition() => false;

  @override
  bool canCombineMultiplications({int? depth}) => false;

  @override
  bool canExpandMultiplications() => false;

  @override
  bool canReduceDivisions() => false;

  @override
  bool canCombinePowers() => false;

  @override
  bool canExpandPowers() => false;

  @override
  bool canDissolvePowerOfPower() => false;

  @override
  bool canDissolvePowerOfComplex() => false;

  @override
  bool canRationalizeComplexDenominator() => false;

  @override
  bool canDistributeExponent() => false;

  @override
  String toString({EquationPrintSpec spec = const EquationPrintSpec()}) => name;

  @override
  String toJson() => name;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is Variable && other.name == name;

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

const t = Variable._('t');

const x = Variable._('x');

const y = Variable._('y');

const z = Variable._('z');

const A = Variable._('A');

const B = Variable._('B');

const C = Variable._('C');

const h1 = Variable._('h1');
const k1 = Variable._('k1');
const r1 = Variable._('r1');
const h2 = Variable._('h2');
const k2 = Variable._('k2');
const r2 = Variable._('r2');

const theta = Variable._('θ');
