import 'package:equation/equation.dart';

export 'quadratic.dart';
export 'quartic.dart';

abstract class Polynomial {
  Eq get discriminant;

  List<Eq> solve();
}