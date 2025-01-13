import 'package:equation/equation.dart';

void main() {
  Eq eq = C(2) * (-(a * x) / b + -c / b) * k;
  print(eq);
  print(eq.simplify());
}
