import 'package:bloc_pattren_sample/api/login_api.dart';
import 'package:bloc_pattren_sample/api/notes_api.dart';
import 'package:bloc_pattren_sample/bloc/actions.dart';
import 'package:bloc_pattren_sample/bloc/app_bloc.dart';
import 'package:bloc_pattren_sample/bloc/app_state.dart';
import 'package:bloc_pattren_sample/dialogs/generic_dialog.dart';
import 'package:bloc_pattren_sample/dialogs/loading_screen.dart';
import 'package:bloc_pattren_sample/models.dart';
import 'package:bloc_pattren_sample/strings.dart';
import 'package:bloc_pattren_sample/views/iterable_list_view.dart';
import 'package:bloc_pattren_sample/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: const NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // display possible errors
            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            // if we have logged in, but we have not fetched notes, fetch the now
            if (state.loginError == null &&
                state.isLoading == false &&
                state.fetchedNotes == null &&
                state.loginHandle == const LoginHandle.fooBar()) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, state) {
            final notes = state.fetchedNotes;

            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
