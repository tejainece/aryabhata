import 'package:equation/equation.dart';

void main() {
  Eq eq = ((a * x - c) / b).pow(C(2));
  print(eq);
  eq = eq.simplifyPowers();
  print(eq);
}
