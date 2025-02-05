import 'package:equation/equation.dart';

void main() {
  final r1 = Variable('r1'), r2 = Variable('r2');

  Eq line = A * x + B * y + C;
  line = (line as Plus).equationOf(y);
  print(line.toString());

  Eq ellipse =
      ((x - h) * Cos(theta) + (y - k) * Sin(theta)).pow(Constant(2)) /
          r1.pow(Constant(2)) +
      ((x - h) * Sin(theta) - (y - k) * Cos(theta)).pow(Constant(2)) /
          r2.pow(Constant(2)) -
      one;

  /*
  ellipse = ellipse.expandPowers();
  print(ellipse);

  ellipse = ellipse.expandMultiplications();
  print(ellipse);

  ellipse = ellipse.combineMultiplications();
  print(ellipse);

  ellipse = ellipse.combineAddition();
  print(ellipse);
   */

  ellipse = ellipse.simplify();
  print(ellipse.toString());

  ellipse = ellipse.substitute({'y': line});
  print(ellipse.toString());

  ellipse = ellipse.simplify(dropMinus: true);
  print(ellipse.toString());

  final quad = ellipse.asQuadratic(x);
  print(quad);
}
