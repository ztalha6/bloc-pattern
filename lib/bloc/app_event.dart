part of 'app_bloc.dart';

@immutable
abstract class AppEvent {
  const AppEvent();
}

class LoadNextImageEvent implements AppEvent {
  const LoadNextImageEvent();
}
