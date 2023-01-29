import 'package:bloc_pattren_sample/models.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    bool vaildCreds = await Future.delayed(const Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'foobar');
    return vaildCreds ? const LoginHandle(token: 'foobar') : null;
  }
}
