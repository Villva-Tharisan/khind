part of 'state_cubit.dart';

@immutable
abstract class StateState {
  const StateState();
}

class StateInitial extends StateState {
  const StateInitial();
}

class StateLoading extends StateState {
  const StateLoading();
}

class StateLoaded extends StateState {
  final List<States> state;

  StateLoaded(this.state);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StateLoaded && listEquals(other.state, state);
  }

  @override
  int get hashCode => state.hashCode;
}
