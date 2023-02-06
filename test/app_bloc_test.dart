import 'package:bloc_pattren_sample/api/login_api.dart';
import 'package:bloc_pattren_sample/api/notes_api.dart';
import 'package:bloc_pattren_sample/bloc/actions.dart';
import 'package:bloc_pattren_sample/bloc/app_bloc.dart';
import 'package:bloc_pattren_sample/bloc/app_state.dart';
import 'package:bloc_pattren_sample/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummayNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummayNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummayNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    }
    return null;
  }
}

@immutable
class DummayLoginAPI implements LoginApiProtocol {
  final String? acceptedEmail;
  final String? acceptedPassword;
  final LoginHandle? loginHandleToReturned;

  const DummayLoginAPI({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.loginHandleToReturned,
  });

  const DummayLoginAPI.empty()
      : acceptedEmail = null,
        acceptedPassword = null,
        loginHandleToReturned = null;

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return loginHandleToReturned;
    }
    return null;
  }
}

void main() {
  blocTest<AppBloc, AppState>(
    'Inital state of app block should be empty',
    build: () => AppBloc(
      acceptableLoginHandle: const LoginHandle(token: 'ABC'),
      loginApi: const DummayLoginAPI.empty(),
      notesApi: const DummayNotesApi.empty(),
    ),
    // act: (bloc) => bloc.add(MyEvent),
    verify: (appState) => expect(appState.state, const AppState.empty()),
  );
  blocTest<AppBloc, AppState>(
    'can we login with correct credentials?',
    build: () => AppBloc(
      acceptableLoginHandle: const LoginHandle(token: 'ABC'),
      loginApi: const DummayLoginAPI(
        acceptedEmail: 'talha@gmail.com',
        acceptedPassword: 'talha',
        loginHandleToReturned: LoginHandle(token: 'ABC'),
      ),
      notesApi: const DummayNotesApi.empty(),
    ),
    act: (bloc) => bloc.add(
      const LoginAction(
        email: 'talha@gmail.com',
        password: 'talha',
      ),
    ),
    expect: () => [
      const AppState(isLoading: true),
      const AppState(
        isLoading: false,
        loginHandle: LoginHandle(token: 'ABC '),
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'we should not be able to login with invalid credentials',
    build: () => AppBloc(
      acceptableLoginHandle: const LoginHandle(token: 'ABC'),
      loginApi: const DummayLoginAPI(
        acceptedEmail: 'talha@gmail.com',
        acceptedPassword: 'talha',
        loginHandleToReturned: LoginHandle(token: 'ABC'),
      ),
      notesApi: const DummayNotesApi.empty(),
    ),
    act: (bloc) => bloc.add(
      const LoginAction(
        email: 'talha@gmail.com',
        password: 'talha1',
      ),
    ),
    expect: () => [
      const AppState(isLoading: true),
      const AppState(
        isLoading: false,
        loginError: LoginError.invalidCredentials,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'load some notes with valid credentials',
    build: () => AppBloc(
      loginApi: const DummayLoginAPI(
        acceptedEmail: 'talha@gmail.com',
        acceptedPassword: 'talha',
        loginHandleToReturned: LoginHandle(token: 'ABC'),
      ),
      notesApi: const DummayNotesApi(
        acceptedLoginHandle: LoginHandle(token: 'ABC'),
        notesToReturnForAcceptedLoginHandle: mockNotes,
      ),
      acceptableLoginHandle: const LoginHandle(token: 'ABC'),
    ),
    act: (bloc) {
      bloc.add(
        const LoginAction(
          email: 'talha@gmail.com',
          password: 'talha',
        ),
      );
      bloc.add(
        const LoadNotesAction(),
      );
    },
    expect: () => [
      const AppState(isLoading: true),
      const AppState(
        isLoading: false,
        loginHandle: LoginHandle(token: 'ABC'),
      ),
      const AppState(
        isLoading: true,
        loginHandle: LoginHandle(token: 'ABC'),
      ),
      const AppState(
        isLoading: false,
        fetchedNotes: mockNotes,
      ),
    ],
  );
}
