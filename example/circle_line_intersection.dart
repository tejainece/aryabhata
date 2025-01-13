import 'package:equation/equation.dart';

void main() {
  Eq line = a * x + b * y + c;
  print(line);
  line = (line as Plus).equationOf(y);
  print(line);

  Eq circle = (x - h).pow(C(2)) - (y - k).pow(C(2)) - r.pow(C(2));
  print(circle);
  circle = circle.expandMultiplications().simplify();
  print(circle);

  circle = circle.substitute({'y': line});
  print(circle);
  circle = circle.simplifyPowers();
  print(circle);

  circle = circle.expandMultiplications();
  print(circle);

  circle = circle.expandDivisions();
  print(circle);

  circle = circle.expandPlus();
  print(circle);

  circle = circle.simplify();
  print(circle);

  /*final quad = circle.asQuadratic(x);
  print(quad);*/
}
