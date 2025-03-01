import 'package:aryabhata/aryabhata.dart';

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

  /*{
    final eq = h / (a.pow(2) / b.pow(2) + 1);
    final res = eq.reduceDivisions();
    print(res);
  }

  {
    final eq = (a.pow(2) / b.pow(2) + 1);
    final res = eq.multiplicativeTerms();
    print(res);
  }*/

  /*{
    Eq eq = h/(one + a.pow(2)/b.pow(2));
    eq = eq.reduceDivisions();
    print(eq.toString());
    eq = eq.simplify();
    print(eq);
  }*/

  /*{
    Eq eq = a/b.pow(2) + c/b + 1 ;
    eq = eq.multiplicativeTerms();
    print(eq);
    eq = eq.simplify();
    print(eq);
  }*/

  /*{
    Eq eq = b.pow(2) * a.pow(2) / b.pow(2);
    eq = eq.simplify();
    print(eq);
  }*/

  /*{
    Eq eq = one/b.pow(2);
    print(eq);
  }*/

  /*{
    Eq eq = (a / b + a / b.pow(2));
    final res = eq.multiplicativeTerms();
    print(res);
  }*/

  /*{
    final res = b.pow(-2).tryCancelDivision(b.pow(-1));
    print(res);
  }*/

  /*{
    Eq eq =
        h / (a.pow(2) / b.pow(2) + 1) -
        a * c / (b.pow(2) + a.pow(2) / b.pow(2));
  }*/

  /*{
    Eq eq = h / (a.pow(2) / b.pow(2) + 1);
    Eq res = eq.simplify();
    Eq res1 = eq.reduceDivisions();
    print(res);
    print(res1);
  }*/

  {
    Eq eq = Plus([i, 0]);
    print(eq.multiplicativeTerms());
  }
}
