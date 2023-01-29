import 'package:flutter/material.dart';

typedef CloseLoadingScreen = bool Function();
typedef UptateLoadingScreen = bool Function(String text);

@immutable
class LoadingController {
  final CloseLoadingScreen close;
  final UptateLoadingScreen update;

  const LoadingController({
    required this.close,
    required this.update,
  });
}
