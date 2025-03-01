import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';

void main() {
  Eq ellipse =
      ((x - h) * Cos(theta) + (y - k) * Sin(theta)).pow(Constant(2)) /
          r1.pow(Constant(2)) +
      ((x - h) * Sin(theta) - (y - k) * Cos(theta)).pow(Constant(2)) /
          r2.pow(Constant(2)) -
      one;
  ellipse = ellipse.simplify();
  print(ellipse);

  final quad = ellipse.asQuadratic(x);
  print(quad);
  print(quad.solve());
}
