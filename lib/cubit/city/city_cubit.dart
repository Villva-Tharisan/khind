import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:khind/models/city.dart';
import 'package:khind/util/api.dart';
import 'package:meta/meta.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityInitial());

  Future<void> fetchCities(String stateId) async {
    emit(CityLoading());

    final response =
        await Api.bearerGet('provider/city.php?state_id=$stateId', isCms: true);

    var cities =
        (response['city'] as List).map((i) => City.fromJson(i)).toList();

    // cities = cities.toSet().toList();

    List<City> citiesSorted = [cities[0]];

    for (var i = 0; i < cities.length; i++) {
      bool exist = true;

      for (var j = 0; j < citiesSorted.length; j++) {
        if (citiesSorted[j].city == cities[i].city) {
          exist = true;
          break;
        } else {
          exist = false;
        }
      }

      // print('state is $exist');
      if (!exist) {
        citiesSorted.add(cities[i]);
      }
    }

    List<String> postcodeList = [];

    emit(CityLoaded(citiesSorted));
  }
}
