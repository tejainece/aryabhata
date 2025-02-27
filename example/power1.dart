import 'package:equation/equation.dart';
import 'package:equation/variables.dart';

void main() {
  /*{
    Eq eq = (x.pow(y)).lpow(z);
    print(eq.simplify());
  }*/

  {
    Eq eq = b.pow(2).lpow(-1).lpow(-1);
    Eq res = eq.dissolvePowerOfPower();
    print(res);
  }
}