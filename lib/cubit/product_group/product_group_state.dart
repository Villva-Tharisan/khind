part of 'product_group_cubit.dart';

@immutable
abstract class ProductGroupState {
  const ProductGroupState();
}

class ProductGroupInitial extends ProductGroupState {
  const ProductGroupInitial();
}

class ProductGroupLoading extends ProductGroupState {
  const ProductGroupLoading();
}

class ProductGroupLoaded extends ProductGroupState {
  final List<String> productModel;

  ProductGroupLoaded(this.productModel);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductGroupLoaded &&
        listEquals(other.productModel, productModel);
  }

  @override
  int get hashCode => productModel.hashCode;
}
