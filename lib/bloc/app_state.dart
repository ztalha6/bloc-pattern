import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:bloc_pattren_sample/auth/auth_errors.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    this.isLoading = false,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required super.isLoading,
    required this.user,
    required this.images,
    super.authError,
  });

  @override
  String toString() =>
      'AppStateLoggedIn(user: ${user.uid}, images: ${images.length})';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    super.isLoading = false,
    super.authError,
  });

  @override
  String toString() =>
      'AppStateLoggedOut(isLaoding: $isLoading, AuthError: $authError)';
}

@immutable
class AppStateInRegistrationView extends AppState {
  const AppStateInRegistrationView({super.isLoading, super.authError});

  @override
  String toString() =>
      'AppStateInRegistrationView(isLaoding: $isLoading, AuthError: $authError)';
}

extension GetUser on AppState {
  User? get user => (this as AppStateLoggedIn).user;
  // final cls = this;
  // if (cls is AppStateLoggedIn) {
  //   return cls.user;
  // }
  // return null;
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    return (this as AppStateLoggedIn).images;
    // final cls = this;
    // if (cls is AppStateLoggedIn) {
    //   return cls.user;
    // }
    // return null;
  }
}
