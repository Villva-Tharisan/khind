part of 'store_cubit.dart';

@immutable
abstract class StoreState {
  const StoreState();
}

class StoreInitial extends StoreState {
  const StoreInitial();
}

class StoreLoading extends StoreState {
  const StoreLoading();
}

class StoreLoaded extends StoreState {
  final Store store;

  StoreLoaded(this.store);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreLoaded && other.store == store;
  }

  @override
  int get hashCode => store.hashCode;
}
