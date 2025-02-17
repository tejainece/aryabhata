import 'package:equation/equation.dart';

void main() {
  Eq line = a * x + b * y + c;
  line = (line as Plus).equationOf(y);
  print(line);

  Eq circle =
      (x - h).pow(Constant(2)) + (y - k).pow(Constant(2)) - r.pow(Constant(2));
  print(circle);

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
  // print(quad);
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
  var [sol1, sol2] = quad.solve();
  sol1 = sol1.simplify();
  print(sol1);
  sol2 = sol2.simplify();
  print(sol2);

  sol1 =
      sol1.substitute({
        'h': Constant(0),
        'k': Constant(0),
        'c': Constant(0),
        'a': Constant(200),
        'b': Constant(-200),
        'r': Constant(100),
      }).simplify();
  print(sol1);
  sol2 =
      sol2.substitute({
        'h': Constant(0),
        'k': Constant(0),
        'c': Constant(0),
        'a': Constant(200),
        'b': Constant(-200),
        'r': Constant(100),
      }).simplify();
  print(sol2);

  print(
    line.substitute({
      'c': Constant(0),
      'a': Constant(200),
      'b': Constant(-200),
      'x': sol1,
    }).simplify(),
  );
  print(
    line.substitute({
      'c': Constant(0),
      'a': Constant(200),
      'b': Constant(-200),
      'x': sol2,
    }).simplify(),
  );
}
