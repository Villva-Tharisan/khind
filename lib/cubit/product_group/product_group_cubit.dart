import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:khind/models/product_group.dart';
import 'package:khind/services/repositories.dart';
import 'package:meta/meta.dart';

part 'product_group_state.dart';

class ProductGroupCubit extends Cubit<ProductGroupState> {
  ProductGroupCubit() : super(ProductGroupInitial());

  Future<void> getProductGroup() async {
    emit(ProductGroupLoading());

    //process

    ProductGroup productGroup = await Repositories.getProductGroup();

    List<String> productList = [];

    for (var i = 0; i < productGroup.data!.length; i++) {
      productList.add(productGroup.data![i].productGroupDescription!);
    }

    productList = productList.toSet().toList();

    emit(ProductGroupLoaded(productList));
  }
}
