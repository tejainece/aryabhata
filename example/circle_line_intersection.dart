import 'package:equation/equation.dart';

void main() {
  Eq line = a * x + b * y + c;
  line = (line as Plus).equationOf(y);
  print(line.toString(spec: printer));

  Eq circle =
      (x - h).pow(Constant(2)) - (y - k).pow(Constant(2)) - r.pow(Constant(2));
  print(circle.toString(spec: printer));

  print('Expand multiplications');
  circle = circle.simplify();
  print(circle.toString(spec: printer));

  print('substituting y');
  circle = circle.substitute({'y': line});
  print(circle.toString(spec: printer));

  circle = circle.simplify(dropMinus: true);
  print(circle);

  final quad = circle.asQuadratic(x);
  print(quad);
}

final printer = EquationPrintSpec();
