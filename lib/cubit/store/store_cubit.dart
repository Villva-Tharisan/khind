import 'package:bloc/bloc.dart';
import 'package:khind/models/store.dart';
import 'package:khind/services/repositories.dart';
import 'package:meta/meta.dart';

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(StoreInitial());

  Future<void> getStore() async {
    emit(StoreLoading());

    //process

    Store store = await Repositories.getStore();

    emit(StoreLoaded(store));
  }
}
