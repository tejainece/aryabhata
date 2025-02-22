import 'package:equation/equation.dart';

class Quartic implements Polynomial {
  final Eq c4;
  final Eq c3;
  final Eq c2;
  final Eq c1;
  final Eq c0;

  Quartic(this.c4, this.c3, this.c2, this.c1, this.c0);

  @override
  Eq get discriminant {
    final k =
        (c3 * c3 * c2 * c2 * c1 * c1) -
        (c1 * c1 * c1 * c3 * c3 * c3 * 4) -
        (c1 * c1 * c2 * c2 * c2 * c4 * 4) +
        (c1 * c1 * c1 * c2 * c3 * c4 * 18) -
        (c1 * c1 * c1 * c1 * c4 * c4 * 27) +
        (c0 * c0 * c0 * c4 * c4 * c4 * 256);

    final p =
        c0 *
        ((c2 * c2 * c2 * c3 * c3 * -4) +
            (c3 * c3 * c3 * c2 * c1 * 18) +
            (c2 * c2 * c2 * c2 * c4 * 16) -
            (c1 * c2 * c2 * c3 * c4 * 80) -
            (c1 * c1 * c3 * c3 * c4 * 6) +
            (c1 * c1 * c4 * c4 * c2 * 144));

    final r =
        (c0 * c0) *
        (c3 * c3 * c3 * c3 * -27 +
            c3 * c3 * c2 * c4 * 144 -
            c4 * c4 * c2 * c2 * 128 -
            c1 * c3 * c4 * c4 * 192);

    return k + p + r;
  }

  @override
  List<Eq> solve() {
    final fb = c3 / c4;
    final fc = c2 / c4;
    final fd = c1 / c4;
    final fe = c0 / c4;

    final q1 = (fc * fc) - (fb * fd * 3) + (fe * 12);
    final q2 =
        (fc.pow(3) * 2) -
        (fb * fc * fd * 9) +
        (fd.pow(2) * 27) +
        (fb.pow(2) * fe * 27) -
        (fc * fe * 72);
    final q3 = (fb * fc * 8) - (fd * 16) - (fb.pow(3) * 2);
    final q4 = (fb.pow(2) * 3) - (fc * 8);

    Eq temp = (q2 * q2 / 4) - (q1.pow(3));
    // TODO temp = -temp.simplify();
    final q5 = (temp.pow(0.5) + (q2 / 2)).pow(1.0 / 3.0);
    final q6 = ((q1 / q5) + q5) / 3;
    temp = (q4 / 12) + q6;
    final q7 = temp.pow(0.5) * 2;
    temp = ((q4 * 4) / 6) - (q6 * 4) - (q3 / q7);

    final solutions = <Eq>[
      (-fb - q7 - temp.pow(0.5)) / 4,
      (-fb - q7 + temp.pow(0.5)) / 4,
    ];

    temp = ((q4 * 4) / 6) - (q6 * 4) + (q3 / q7);

    solutions
      ..add((-fb + q7 - temp.pow(0.5)) / 4)
      ..add((-fb + q7 + temp.pow(0.5)) / 4);

    for (var i = 0; i < solutions.length; i++) {
      solutions[i] = solutions[i].simplify();
    }

    return solutions;
  }

  @override
  String toString() => 'c4=$c4, c3=$c3, c2=$c2, c1=$c1, c0=$c0';
}

extension QuarticEqExt on Eq {
  Quartic asQuartic(Variable x) {
    var simplified = simplify();
    if (simplified is! Plus) {
      simplified = Plus([simplified]);
    }
    final coeffs = List<List<Eq>>.generate(5, (_) => <Eq>[]);
    outer:
    for (var term in simplified.expressions) {
      for (int i = 0; i <= 4; i++) {
        Eq tmp = (term / x.pow(i)).simplify();
        if (!tmp.hasVariable(x)) {
          coeffs[i].add(tmp);
          continue outer;
        }
      }
      throw UnsupportedError('$term not a polynomial');
    }

    return Quartic(
      coeffs[4].isEmpty ? Constant(0) : Plus(coeffs[4]),
      coeffs[3].isEmpty ? Constant(0) : Plus(coeffs[3]),
      coeffs[2].isEmpty ? Constant(0) : Plus(coeffs[2]),
      coeffs[1].isEmpty ? Constant(0) : Plus(coeffs[1]),
      coeffs[0].isEmpty ? Constant(0) : Plus(coeffs[0]),
    );
  }
}
