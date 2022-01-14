part of 'product_model_cubit.dart';

@immutable
abstract class ProductModelState {
  const ProductModelState();
}

class ProductModelInitial extends ProductModelState {
  const ProductModelInitial();
}

class ProductModelLoading extends ProductModelState {
  const ProductModelLoading();
}

class ProductModelLoaded extends ProductModelState {
  final List<String> productModel;
  final List<String> modelDescription;

  ProductModelLoaded(this.productModel, this.modelDescription);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModelLoaded &&
        listEquals(other.productModel, productModel) &&
        listEquals(other.modelDescription, modelDescription);
  }

  @override
  int get hashCode => productModel.hashCode ^ modelDescription.hashCode;
}
