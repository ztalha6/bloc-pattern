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

  @override
  String toString() =>
      'AppState(isLoading: $isLoading, data: ${data != null}, error: $error)';
}

class AppInitial extends AppState {
  const AppInitial({super.isLoading = false});
}
