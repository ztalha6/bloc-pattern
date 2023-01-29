// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
class LoginHandle {
  final String token;

  const LoginHandle({required this.token});

  const LoginHandle.fooBar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandle other) {
    if (identical(this, other)) return true;
    return other.token == token;
  }

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginHandle(token: $token)';
}

enum LoginError {
  invalidCredentials('Invalid credentials');

  final String value;
  const LoginError(this.value);
}

class Notes {
  final String title;

  Notes({required this.title});

  @override
  String toString() => 'Notes(title: $title)';
}

final mockNotes = Iterable.generate(
  3,
  ((index) => Notes(
        title: 'title ${index + 1}',
      )),
);
