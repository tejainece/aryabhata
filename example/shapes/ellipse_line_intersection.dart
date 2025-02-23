import 'package:equation/equation.dart';

void main() {
  final r1 = Variable('r1'), r2 = Variable('r2');

  Eq line = a * x + b * y + c;
  line = (line as Plus).equationOf(y);
  print(line);

  Eq ellipse =
      ((x - h) * Cos(theta) + (y - k) * Sin(theta)).pow(Constant(2)) /
          r1.pow(Constant(2)) +
      ((x - h) * Sin(theta) - (y - k) * Cos(theta)).pow(Constant(2)) /
          r2.pow(Constant(2)) -
      one;
  ellipse = ellipse.simplify();
  print(ellipse);

  ellipse = ellipse.substitute({'y': line});
  print(ellipse.toString());

  ellipse = ellipse.simplify(equalsZero: true);
  print(ellipse.toString());

  print(
    '-----------------------------SOLUTIONS------------------------------------',
  );
  final quad = ellipse.asQuadratic(x);
  print(quad);
  Eq discriminant = quad.discriminant;
  discriminant = discriminant.simplify(debug: true);
  print(discriminant);
  final solutions = quad.solve();
  for (final sol in solutions) {
    print(sol.toString(spec: EquationPrintSpec(times: '*')));
  }

  print(
    '-----------------------------INTERSECT POINTS-----------------------------',
  );
  final subs = {
    theta.name: Eq.c(0),
    'r1': Eq.c(100),
    'r2': Eq.c(100),
    'h': Constant(0),
    'k': Constant(0),
    'c': Constant(0),
    'a': Constant(200),
    'b': Constant(-200),
  };

  print('A: ${quad.c2.substitute(subs).simplify()}');

  {
    Eq first = solutions.first;
    first =
        first.substitute(subs).simplify();
    print(first);

    Eq second = solutions[1];
    second =
        second.substitute(subs).simplify();
    print(second);
  }
}
