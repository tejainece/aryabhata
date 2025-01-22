import 'package:equation/equation.dart';

void main() {
  Eq line = a * x + b * y + c;
  line = (line as Plus).equationOf(y);
  print(line);

  Eq circle =
      (x - h).pow(Constant(2)) - (y - k).pow(Constant(2)) - r.pow(Constant(2));
  print(circle);
  print('Expand multiplications');
  circle =
      circle
          .expandMultiplications()
          .combineAddition()
          .combineMultiplications();
  print(circle);

  print('substituting y');
  circle = circle.substitute({'y': line});
  print(circle);
  print('distributing exponent');
  circle = circle.distributeExponent();
  print(circle);

  print('expanding multiplications');
  circle = circle.expandMultiplications();
  print(circle);

  circle = circle.simplifyDivisionOfAddition();
  print(circle);

  circle = circle.combineAddition();
  print(circle);

  circle = circle.simplify();
  print(circle);

  circle = circle.expandMultiplications();
  print(circle);

  circle = circle.combineAddition();
  print(circle);

  /*final quad = circle.asQuadratic(x);
  print(quad);*/
}
