import 'package:bloc_pattren_sample/models.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}

@immutable
class NotesApi implements NotesApiProtocol {
  const NotesApi();

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    bool vaildHandle = await Future.delayed(
      const Duration(seconds: 2),
      () => loginHandle == const LoginHandle.fooBar(),
    );
    return vaildHandle ? mockNotes : null;
  }
}
