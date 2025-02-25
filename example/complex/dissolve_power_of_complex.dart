import 'package:equation/equation.dart';

void main() {
  {
    Power eq = (Eq.c(1) + i * 2).pow(0.5);
    Eq simplified = eq.dissolvePowerOfComplex();
    print(simplified);
    simplified = simplified.simplify();
    print(simplified);
  }
  {
    Power eq = (Eq.c(35) + i * 31.176914536239792).pow(-0.16666666666666666);
    Eq simplified = eq.dissolvePowerOfComplex();
    print(simplified);
    simplified = simplified.simplify();
    print(simplified);
  }
}
