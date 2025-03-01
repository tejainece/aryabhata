import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';

void main() {
  Eq eqX = h1 + r1 * (Eq.c(1) - t.pow(2)) / (Eq.c(1) + t.pow(2));
  eqX = eqX.simplify();
  print(eqX);
  Eq eqY = k1 + r1 * 2 * t / (Eq.c(1) + t.pow(2));
  eqY = eqY.simplify();
  print(eqY);
  print(eqX.substitute({'t': Eq.c(1)}).simplify());

  Eq ellipse =
      ((x - h2) * Cos(theta) + (y - k2) * Sin(theta)).pow(Constant(2)) /
          r2.pow(Constant(2)) +
          ((x - h2) * Sin(theta) - (y - k2) * Cos(theta)).pow(Constant(2)) /
              r3.pow(Constant(2)) -
          one;
  ellipse = ellipse.simplify();
  print(ellipse);

  ellipse = ellipse.substitute({
    'x': eqX,
    'y': eqY,
  });
  ellipse = ellipse.simplify();
  print(ellipse);
  ellipse = (ellipse as Plus).simplifyEq0();
  print(ellipse);
}
