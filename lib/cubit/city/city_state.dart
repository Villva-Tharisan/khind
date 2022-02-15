part of 'city_cubit.dart';

@immutable
abstract class CityState {
  const CityState();
}

class CityInitial extends CityState {
  const CityInitial();
}

class CityLoading extends CityState {
  const CityLoading();
}

class CityLoaded extends CityState {
  final List<City> cities;

  CityLoaded(this.cities);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityLoaded && listEquals(other.cities, cities);
  }

  @override
  int get hashCode => cities.hashCode;
}
