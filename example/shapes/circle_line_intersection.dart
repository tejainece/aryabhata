import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';

void main() {
  Eq line = a * x + b * y + c;
  line = (line as Plus).equationOf(y);
  print(line);

  Eq circle =
      (x - h).pow(Constant(2)) + (y - k).pow(Constant(2)) - r.pow(Constant(2));
  circle = circle.simplify();
  print(circle);

  print('substituting y');
  circle = circle.substitute({'y': line});
  print(circle);

  circle = circle.simplify(equalsZero: true);
  print(circle);

  /* TODO substitute
  print('-----------------------------------------------------------------');
  Eq substituted = circle.substitute({
    'h': Constant(0),
    'k': Constant(0),
    'c': Constant(0),
    'a': Constant(200),
    'b': Constant(-200),
    'r': Constant(100),
    'x': Constant(70.7106781187),
  });
  print(substituted);
  print(substituted.simplify());
   */

  print(
    '------------------------------QUADRATIC-----------------------------------',
  );
  final quad = circle.asQuadratic(x);
  print(quad.discriminant);
  print(quad);
  print(
    quad.discriminant.substitute({
      'h': Constant(0),
      'k': Constant(0),
      'c': Constant(0),
      'a': Constant(200),
      'b': Constant(-200),
      'r': Constant(100),
    }).simplify(),
  );

  print(
    '-----------------------------SOLUTIONS------------------------------------',
  );
  var [x1, x2] = quad.solve();
  print(x1);
  print(x2);

  x1 =
      x1.substitute({
        'h': Constant(0),
        'k': Constant(0),
        'c': Constant(0),
        'a': Constant(200),
        'b': Constant(-200),
        'r': Constant(100),
      }).simplify();
  print(x1);
  x2 =
      x2.substitute({
        'h': Constant(0),
        'k': Constant(0),
        'c': Constant(0),
        'a': Constant(200),
        'b': Constant(-200),
        'r': Constant(100),
      }).simplify();
  print(x2);

  Eq y1 = line.substitute({
    'c': Constant(0),
    'a': Constant(200),
    'b': Constant(-200),
    'x': x1,
  });
  print(y1.simplify());
  Eq y2 =
      line.substitute({
        'c': Constant(0),
        'a': Constant(200),
        'b': Constant(-200),
        'x': x2,
      }).simplify();
  print(y2);
}
