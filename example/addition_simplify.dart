import 'package:equation/equation.dart';
import 'package:equation/variables.dart';

void main() {
  Eq eq;
  /*eq = x * C(2) + C(5);
  print('$eq => ${eq.simplify()}');

  eq = C(2) + x + C(5);
  print('$eq => ${eq.simplify()}');*/

  eq = Constant(-4 * 3) * x + Constant(-8) * y;
  print('$eq => ${eq.separateConstant()}');
  print('$eq => $eq');
}
