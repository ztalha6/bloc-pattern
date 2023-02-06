import 'package:bloc_pattren_sample/api/login_api.dart';
import 'package:bloc_pattren_sample/api/notes_api.dart';
import 'package:bloc_pattren_sample/bloc/actions.dart';
import 'package:bloc_pattren_sample/bloc/app_state.dart';
import 'package:bloc_pattren_sample/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;
  final LoginHandle acceptableLoginHandle;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
    required this.acceptableLoginHandle,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        //* start the loading
        emit(
          const AppState(isLoading: true),
        );

        //* login the user
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );
        emit(
          AppState(
            isLoading: false,
            loginError:
                loginHandle == null ? LoginError.invalidCredentials : null,
            loginHandle: loginHandle,
          ),
        );
      },
    );

    on<LoadNotesAction>(
      (event, emit) async {
        //* start the loading
        emit(
          AppState(
            isLoading: true,
            loginHandle: state.loginHandle,
          ),
        );

        //* get the login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != acceptableLoginHandle) {
          emit(
            AppState(
              isLoading: false,
              loginError: LoginError.invalidCredentials,
              loginHandle: loginHandle,
            ),
          );
          return;
        }
        //* we have valid login handle to fetch notes
        final notes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(
          AppState(
            isLoading: false,
            fetchedNotes: notes,
          ),
        );
      },
    );
  }
}
