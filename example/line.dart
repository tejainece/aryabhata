import 'package:equation/equation.dart';

void main() {
  var line = a * x + b * y + c;
  print(line);
  var res = line.equationOf(y);
  print(res);
}