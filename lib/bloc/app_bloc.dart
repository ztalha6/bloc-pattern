import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'dart:math' as math;

part 'app_event.dart';
part 'app_state.dart';

typedef AppBlocRAndomUrlPicker = String Function(Iterable<String> allUrlls);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRAndomUrlPicker? urlPicker,
  }) : super(const AppInitial()) {
    on<LoadNextImageEvent>(
      (event, emit) async {
        emit(
          const AppState(isLoading: true),
        );
        final url = (urlPicker ?? _pickRandomUrl)(urls);
        try {
          if (waitBeforeLoading != null) {
            await Future.delayed(waitBeforeLoading);
          }
          final NetworkAssetBundle bundle = NetworkAssetBundle(Uri.parse(url));
          final Uint8List imageData =
              (await bundle.load(url)).buffer.asUint8List();
          emit(
            AppState(data: imageData),
          );
        } catch (e) {
          emit(
            AppState(error: e),
          );
        }
      },
    );
  }
}
