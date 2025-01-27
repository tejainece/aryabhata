import 'package:equation/equation.dart';

void main() {
  Eq line = a * x + b * y + c;
  line = (line as Plus).equationOf(y);
  print(line.toString(spec: printer));

  Eq circle =
      (x - h).pow(Constant(2)) - (y - k).pow(Constant(2)) - r.pow(Constant(2));
  print(circle.toString(spec: printer));
  print('Expand multiplications');
  circle =
      circle.expandMultiplications().combineAddition().combineMultiplications();
  print(circle.toString(spec: printer));

  print('substituting y');
  circle = circle.substitute({'y': line});
  print(circle.toString(spec: printer));

  print('distributing exponent');
  circle = circle.distributeExponent();
  print(circle.toString(spec: printer));

  print('Dissolve minus');
  circle = circle.factorOutMinus().dropMinus();
  print(circle.toString(spec: printer));

  print('expand multiplications');
  circle = circle.expandMultiplications();
  circle = circle.combineMultiplications();
  print(circle.toString(spec: printer));

  print('Combine additions');
  circle = circle.combineAddition();
  print(circle.toString(spec: printer));

  final quad = circle.asQuadratic(x);
  print(quad);
}

final printer = EquationPrintSpec(times: '');
