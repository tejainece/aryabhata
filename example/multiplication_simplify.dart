import 'package:equation/equation.dart';

void main() {
  /*{
    Eq eq = Eq.c(1) * Eq.c(2);
    Eq simplified = eq.simplify();
    print(simplified);
  }*/

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

  /*Eq eq = x / y / z;
  print(eq);
  eq = eq.simplify();
  print(eq);*/

  /*{
    Eq eq = (x * y).pow(Eq.c(2)) * (Eq.c(1) + Eq.c(2));
    print(eq);
  }*/

  {
    Eq eq =
        (Eq.c(4) + Eq.c(8) * x + Eq.c(12) * y).pow(Eq.c(0.5)) / (Eq.c(4) * a);
    print(eq.simplify());
  }

  {
    Eq eq = (a + a.pow(Eq.c(2)) + a.pow(Eq.c(3))).pow(Eq.c(0.5)) / a;
    print(eq.simplify());
  }

  {
    Eq eq = (a + a.pow(Eq.c(2)) + a.pow(Eq.c(3))).pow(Eq.c(2)) / a;
    print(eq.simplify());
  }

  {
    Eq eq = (a + a.pow(Eq.c(2)) + a.pow(Eq.c(3))).pow(Eq.c(2)) / (a + a * b);
    print(eq.simplify());
  }
}
