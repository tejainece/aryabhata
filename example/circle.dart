import 'package:equation/equation.dart';
import 'package:equation/variables.dart';

void main() {
  /*
  var eq1 = (x * x)/(r * r) + (y * y)/(r * r) - C(1);
  var eq2 = a * x + b * y + c;*/

  var eq1 = (x - h) * (x - h) + (y - k) * (y - k) - r * r;
  print(eq1);
}