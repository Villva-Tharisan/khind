import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:khind/models/city.dart';
import 'package:khind/util/api.dart';
import 'package:meta/meta.dart';

part 'postcode_state.dart';

class PostcodeCubit extends Cubit<PostcodeState> {
  PostcodeCubit() : super(PostcodeInitial());

  Future<void> getPostcode(String city, String stateId) async {
    emit(PostcodeLoading());

    print('city is $city');
    print('stateid is $stateId');

    final response =
        await Api.bearerGet('provider/city.php?state_id=$stateId', isCms: true);

    var cities =
        (response['city'] as List).map((i) => City.fromJson(i)).toList();

    List<int> postcode = [];

    for (var i = 0; i < cities.length; i++) {
      // print('masuk $i');
      if (cities[i].city == city) {
        postcode.add(int.parse(cities[i].postcode!));
      }
    }

    postcode.sort((a, b) => (a.compareTo(b)));

    emit(PostcodeLoaded(postcode));
  }
}
