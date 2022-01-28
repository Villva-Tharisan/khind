part of 'tracker_cubit.dart';

@immutable
abstract class TrackerState {
  const TrackerState();
}

class TrackerInitial extends TrackerState {
  const TrackerInitial();
}

class TrackerLoading extends TrackerState {
  const TrackerLoading();
}

class TrackerLoaded extends TrackerState {
  final List<ProductWarranty> productWarranty;
  final ServiceProduct serviceProduct;

  TrackerLoaded({required this.productWarranty, required this.serviceProduct});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrackerLoaded &&
        listEquals(other.productWarranty, productWarranty) &&
        other.serviceProduct == serviceProduct;
  }

  @override
  int get hashCode => productWarranty.hashCode ^ serviceProduct.hashCode;
}
