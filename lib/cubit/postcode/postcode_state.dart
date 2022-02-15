part of 'postcode_cubit.dart';

@immutable
abstract class PostcodeState {
  const PostcodeState();
}

class PostcodeInitial extends PostcodeState {
  const PostcodeInitial();
}

class PostcodeLoading extends PostcodeState {
  const PostcodeLoading();
}

class PostcodeLoaded extends PostcodeState {
  final List<int> postcode;

  PostcodeLoaded(this.postcode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostcodeLoaded && listEquals(other.postcode, postcode);
  }

  @override
  int get hashCode => postcode.hashCode;
}
