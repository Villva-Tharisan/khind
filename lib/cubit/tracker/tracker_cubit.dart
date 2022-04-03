import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:khind/models/product_warranty.dart';
import 'package:khind/models/service_product.dart';
import 'package:khind/services/repositories.dart';

import 'package:meta/meta.dart';

part 'tracker_state.dart';

class TrackerCubit extends Cubit<TrackerState> {
  TrackerCubit() : super(TrackerInitial());

  Future<void> getTracker(String sort) async {
    emit(TrackerLoading());

    //process
    ServiceProduct serviceProduct = await Repositories.getServiceProduct();

    ServiceProduct serviceProductSorted = ServiceProduct(data: []);

    //for sorting

    //pending collection
    if (sort == 'All') {
      for (var i = 0; i < serviceProduct.data!.length; i++) {
        if (serviceProduct.data![i]['service_request_status'] == 'Pending Collection') {
          serviceProductSorted.data!.add(serviceProduct.data![i]);
        }
      }

      //not started
      for (var i = 0; i < serviceProduct.data!.length; i++) {
        if (serviceProduct.data![i]['service_request_status'] == 'Not Started') {
          serviceProductSorted.data!.add(serviceProduct.data![i]);
        }
      }

      //repairing
      for (var i = 0; i < serviceProduct.data!.length; i++) {
        if (serviceProduct.data![i]['service_request_status'] == 'Repairing') {
          serviceProductSorted.data!.add(serviceProduct.data![i]);
        }
      }

      //collected
      for (var i = 0; i < serviceProduct.data!.length; i++) {
        if (serviceProduct.data![i]['service_request_status'] == 'Collected') {
          serviceProductSorted.data!.add(serviceProduct.data![i]);
        }
      }
    } else if (sort == 'Pending Collection') {
      for (var i = 0; i < serviceProduct.data!.length; i++) {
        if (serviceProduct.data![i]['service_request_status'] == 'Pending Collection') {
          serviceProductSorted.data!.add(serviceProduct.data![i]);
        }
      }
    } else if (sort == 'Not Started') {
      for (var i = 0; i < serviceProduct.data!.length; i++) {
        if (serviceProduct.data![i]['service_request_status'] == 'Not Started') {
          serviceProductSorted.data!.add(serviceProduct.data![i]);
        }
      }
    } else if (sort == 'Repairing') {
      for (var i = 0; i < serviceProduct.data!.length; i++) {
        if (serviceProduct.data![i]['service_request_status'] == 'Repairing') {
          serviceProductSorted.data!.add(serviceProduct.data![i]);
        }
      }
    } else if (sort == 'Collected') {
      for (var i = 0; i < serviceProduct.data!.length; i++) {
        if (serviceProduct.data![i]['service_request_status'] == 'Collected') {
          serviceProductSorted.data!.add(serviceProduct.data![i]);
        }
      }
    }

    List<ProductWarranty> productWarranty = [];

    // for (var i = 0; i < serviceProductSorted.data!.length; i++) {
    //   ProductWarranty pw;

    //   try {
    //     pw = productWarrantyFromJson(await Repositories.getProduct(
    //         productModel: serviceProductSorted.data![i]['product_model']!));
    //   } catch (e) {
    //     //dummy
    //     pw = productWarrantyFromJson(
    //         '{"data":[{"product_id":"43","product_group_id":"2","product_model_id":"479","warranty_id":null,"product_code":"SEMFS223XXBKNA","product_description":"MFS223 FOOD STEAMER BK NA","inserted_at":"2021-12-12 04:08:49.730133","updated_at":null,"brand_id":"8","product_group":"HAKASE","product_group_description":"STEAMER","product_model":"MFS223","model_description":"MFS223(FOOD STEAMER)","map_to_product_code":null,"is_active":"1","specific_warranty":null,"drop_in":"0","home_visit":"0","pick_up":"0","service_hours":null,"technician_service_group":null,"rcp":null,"extended_warranty_charge_1yr":null,"repair_with_part_rep_charge_indoor":null,"checking_adj_charge_indoor":null,"checking_adj_charge_outdoor":null,"repair_with_part_rep_charge_outdoor":null,"grr_charge":null,"transport_charge_less_50km":null,"transport_charge_between_50km_100km":null,"transport_charge_greater_100km":null}]}');
    //   }

    //   productWarranty.add(pw);
    // }

    // productWarranty.shuffle();

    // print(productWarranty[0].data![0].productDescription);

    emit(TrackerLoaded(
      serviceProduct: serviceProductSorted,
      productWarranty: productWarranty,
    ));
  }
}
