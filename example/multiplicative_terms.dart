import 'package:equation/equation.dart';

void main() {
  /*
  {
    final eq = a * b;
    print(eq.multiplicativeTerms());
  }

  {
    Eq eq = a * a.pow(-Eq.c(1));
    print(eq.combineMultiplications());
  }*/

  /*{
    final eq = (a + a * b)/(Eq.c(2) * a);
    print(eq.reduceDivisions());
  }*/

  {
    final eq = x / y / z;
    final res = eq.reduceDivisions();
    print(res);
  }
}
