import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:khind/models/states.dart';
import 'package:khind/util/api.dart';
import 'package:meta/meta.dart';

part 'state_state.dart';

class StateCubit extends Cubit<StateState> {
  StateCubit() : super(StateInitial());

  Future<void> getState() async {
    emit(StateLoading());

    final response = await Api.bearerGet('provider/state.php', isCms: true);

    var newStates =
        (response['states'] as List).map((i) => States.fromJson(i)).toList();

    emit(StateLoaded(newStates));
  }
}
