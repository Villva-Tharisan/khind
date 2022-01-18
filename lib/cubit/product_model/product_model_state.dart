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
  final List<String> productName;
  final List<String> modelDescription;
  final List<String> productModel;

  ProductModelLoaded(
      this.productName, this.modelDescription, this.productModel);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModelLoaded &&
        listEquals(other.productName, productName) &&
        listEquals(other.modelDescription, modelDescription) &&
        listEquals(other.productModel, productModel);
  }

  @override
  int get hashCode =>
      productName.hashCode ^ modelDescription.hashCode ^ productModel.hashCode;
}
