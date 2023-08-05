// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

@immutable
class AppState {
  final bool isLoading;
  final Uint8List? data;
  final Object? error;

  const AppState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  factory AppState.empty() {
    return const AppState(isLoading: false);
  }

  @override
  String toString() =>
      'AppState(isLoading: $isLoading, data: ${data != null}, error: $error)';

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        (data ?? []).isEqualTo(other.data ?? []) &&
        other.error == error;
  }

  @override
  int get hashCode => isLoading.hashCode ^ data.hashCode ^ error.hashCode;
}

class AppInitial extends AppState {
  const AppInitial({super.isLoading = false});
}

extension Camparison<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) {
      return true;
    }
    if (length != other.length) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
