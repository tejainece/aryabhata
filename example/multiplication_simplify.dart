import 'package:equation/equation.dart';

void main() {
  /*Eq eq = Constant(2) * (-(a * x) / b + -c / b) * k;
  print(eq);
  print(eq.simplify());*/

  /*
  Eq eq = x / (y * z);
  print(eq);

  eq = (x * y)/(z * z);
  print(eq);

  eq = (a + b)/(z * z);
  print(eq);

  eq = a / (x * y) + b / (x * y);
  print(eq);
   */

  Eq eq = x / y / z;
  print(eq);
  eq = eq.simplify();
  print(eq);
}
