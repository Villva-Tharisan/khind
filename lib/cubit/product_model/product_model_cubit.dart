import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:khind/models/product_group_model.dart';
import 'package:khind/models/product_model.dart';
import 'package:khind/services/repositories.dart';
import 'package:meta/meta.dart';

part 'product_model_state.dart';

class ProductModelCubit extends Cubit<ProductModelState> {
  ProductModelCubit() : super(ProductModelInitial());

  Future<void> getProductModel({required String productGroup}) async {
    emit(ProductModelLoading());

    //process

    ProductGroupModel product =
        await Repositories.getProductModel(productGroup: productGroup);

    List<String> productList = [];
    List<String> productDesc = [];

    print(product.data!.length);

    for (var i = 0; i < product.data!.length; i++) {
      // print(product.data![i]['product_id']);
      productList.add(product.data![i]['product_description']!);
      productDesc.add(product.data![i]['model_description']!);
    }

    print('length 1 is ${productList.length}');
    print('length 2 is ${productDesc.length}');

    emit(ProductModelLoaded(productList, productDesc));
  }
}
