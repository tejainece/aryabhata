import 'package:equation/equation.dart';

void main() {
  final r3 = Variable('r3');
  Eq circle1 =
      (x - h1).pow(Constant(2)) +
      (y - k1).pow(Constant(2)) -
      r1.pow(Constant(2));
  circle1 = circle1.simplify();
  Eq ellipse =
      ((x - h2) * Cos(theta) + (y - k2) * Sin(theta)).pow(Constant(2)) /
          r2.pow(Constant(2)) +
      ((x - h2) * Sin(theta) - (y - k2) * Cos(theta)).pow(Constant(2)) /
          r3.pow(Constant(2)) -
      one;
  ellipse = ellipse.simplify();
  print(circle1);
  print(ellipse);

  Eq diff = circle1 - ellipse;
  diff = diff.simplify();
  print(diff);

  usingYFormula(circle1, diff);
}

void usingXFormula(Eq curve1, Eq diff) {
  Eq eqY = (diff as Plus).equationOf(y);
  print(eqY);

  Eq inX = curve1.substitute({'y': eqY});
  inX = inX.simplify();
  print(inX);

  final subs = {
    'h1': Eq.c(0),
    'k1': Eq.c(0),
    'h2': Eq.c(0),
    'k2': Eq.c(150),
    'r1': Eq.c(100),
    'r2': Eq.c(100),
  };

  final quad = inX.asQuadratic(x);
  print(quad);
  print(
    '${quad.c2.substitute(subs).simplify()} ${quad.c1.substitute(subs).simplify()} ${quad.c0.substitute(subs).simplify()}',
  );
  print(quad.discriminant.substitute(subs).simplify());
  final solutions = quad.solve();
  print(solutions.first);
  final x1 = solutions.first.substitute(subs).simplify();
  print(x1);
  final x2 = solutions[1].substitute(subs).simplify();
  print(x2);
}

void usingYFormula(Eq curve1, Eq diff) {
  Eq eqX = (diff as Plus).equationOf(x);
  print(eqX);

  Eq inY = curve1.substitute({'x': eqX});
  inY = inY.simplify();
  print(inY);

  final subs = {
    'h1': Eq.c(0),
    'k1': Eq.c(0),
    'h2': Eq.c(100),
    'k2': Eq.c(0),
    'r1': Eq.c(100),
    'r2': Eq.c(100),
  };

  final quad = inY.asQuadratic(y);
  print(quad);
  print(
    '${quad.c2.substitute(subs).simplify()} ${quad.c1.substitute(subs).simplify()} ${quad.c0.substitute(subs).simplify()}',
  );
  print(quad.discriminant.substitute(subs).simplify());
  final solutions = quad.solve();
  print(solutions.first);
  final y1 = solutions.first.substitute(subs).simplify();
  print(y1);
  final y2 = solutions[1].substitute(subs).simplify();
  print(y2);
}
