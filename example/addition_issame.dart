import 'package:equation/equation.dart';

void main() {
  var eq1 = C(2) + x + C(5);
  var eq2 = x + C(7);
  print(eq1.isSame(eq2));
}