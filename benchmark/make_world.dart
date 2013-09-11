import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:gentopia/gentopia.dart';

class MakeWorldBenchmark extends BenchmarkBase {
  World w = new World();
  MakeWorldBenchmark() : super("Make World");

  // The benchmark code.
  void run() {
    w.makeTexture(0, 0, 1, 1);
  }
}

main() {
  new MakeWorldBenchmark().report();
}

