import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'dart:math' as math;

part 'app_event.dart';
part 'app_state.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);
typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();
  Future<Uint8List> _loadUrl(String url) async {
    final NetworkAssetBundle bundle = NetworkAssetBundle(Uri.parse(url));
    return (await bundle.load(url)).buffer.asUint8List();
  }

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
    AppBlocUrlLoader? urlLoader,
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

          final Uint8List imageData = await (urlLoader ?? _loadUrl)(url);
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
