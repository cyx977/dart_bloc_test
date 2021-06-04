import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'ggg.dart';

void main() {
  group("bloc test", () {
    blocTest(
      "emits n",
      build: () => CounterBloc(CounterStateLoading(10)),
      act: (CounterBloc counterBloc) => counterBloc.add(EventCounterGet()),
      expect: () {
        return [CounterStateLoadSuccess(25)];
      },
    );
  });
}
