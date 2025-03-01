import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';

void main() {
  /*{
    Eq eq = x.pow(-Eq.c(1).pow(Eq.c(2)));
    eq = eq.simplify();
    print(eq);
  }

  {
    Eq eq = (x.pow(-Eq.c(1))).pow(Eq.c(2));
    eq = eq.simplify();
    print(eq);
  }*/

  /*{
    Eq eq = x.pow(Eq.c(1));
    print(eq.simplify());
    print(eq.canDissolveConstants());
    print(eq.dissolveConstants());
  }*/

  {
    Eq eq = (a.pow(2) / b.pow(2) + 1);
    Eq res = eq.multiplicativeTerms();
    print(res);
  }

  /*{
    Eq eq = h / (a.pow(2) / b.pow(2) + 1);
    Eq res = eq.multiplicativeTerms();
    print(res);
  }*/
}
