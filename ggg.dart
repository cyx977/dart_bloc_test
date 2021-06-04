import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

///event
abstract class CounterEvent {}

class EventCounterGet extends CounterEvent {}

class EventCounterPost extends CounterEvent {}

///state
abstract class CounterState {
  CounterState(this.count);
  final int count;
}

class CounterStateLoading extends CounterState {
  CounterStateLoading(int count) : super(count);
}

class CounterStateLoadSuccess extends CounterState with EquatableMixin {
  CounterStateLoadSuccess(this.count) : super(0);

  final int count;

  @override
  List<Object> get props => [count];

  @override
  bool get stringify => true;
}

class CounterStateLoadFailure extends CounterState {
  CounterStateLoadFailure(int count) : super(count);
}

///bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(CounterState this.initialState) : super(initialState);

  CounterState initialState;

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is EventCounterGet) {
      yield* _mapEventCounterGetToState();
    }
  }
}

Stream<CounterState> _mapEventCounterGetToState() async* {
  final service = CounterService();
  yield await service.fetchCount();
}

///Counter service
class CounterService {
  Future<CounterStateLoadSuccess> fetchCount() async {
    return Future.delayed(Duration(seconds: 1), () {
      // return CounterStateLoadSuccess(Random().nextInt(100));
      return CounterStateLoadSuccess(25);
    });
  }
}

void main() {
  final bloc = CounterBloc(CounterStateLoading(0));
  bloc.stream.listen((CounterState e) {
    print(e.count);
  });
  bloc.add(EventCounterGet());
  bloc.add(EventCounterGet());
  bloc.add(EventCounterGet());
}
