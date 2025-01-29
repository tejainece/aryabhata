import 'package:equation/equation.dart';

void main() {
  Eq line = a * x + b * y + c;
  line = (line as Plus).equationOf(y);
  print(line.toString());

  Eq ellipse =
      ((x - h) * Cos(theta) + (y - k) * Sin(theta)).pow(Constant(2)) /
          a.pow(Constant(2)) +
      ((x - h) * Sin(theta) - (y - k) * Cos(theta)).pow(Constant(2)) /
          b.pow(Constant(2)) -
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
}
