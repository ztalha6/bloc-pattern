import 'dart:typed_data';

import 'package:bloc_pattren_sample/bloc/app_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Inital state of bloc should be empty',
    build: () => AppBloc(urls: []),
    verify: (bloc) => expect(bloc.state, const AppInitial()),
  );

  // load valid data and compare the states
  blocTest<AppBloc, AppState>(
    'Test the ability to load the urls',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (bloc) => bloc.add(const LoadNextImageEvent()),
    expect: () => [
      const AppState(isLoading: true),
      AppState(data: text1Data),
    ],
  );

  // test throwing an exception from url loader
  blocTest<AppBloc, AppState>(
    'Test throwing an exception from url loader',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (bloc) => bloc.add(const LoadNextImageEvent()),
    expect: () => [
      const AppState(isLoading: true),
      const AppState(error: Errors.dummy),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Test the ability to load more then one urls',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (bloc) {
      bloc.add(const LoadNextImageEvent());
      bloc.add(const LoadNextImageEvent());
    },
    expect: () => [
      const AppState(isLoading: true),
      AppState(data: text2Data),
      const AppState(isLoading: true),
      AppState(data: text2Data),
    ],
  );
}
