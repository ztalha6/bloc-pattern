import 'package:bloc_pattren_sample/bloc/app_bloc.dart';
import 'package:bloc_pattren_sample/bloc/app_events.dart';
import 'package:bloc_pattren_sample/bloc/app_state.dart';
import 'package:bloc_pattren_sample/dialog/auth_error_dialog.dart';
import 'package:bloc_pattren_sample/loading/loading_screen.dart';
import 'package:bloc_pattren_sample/views/login_view.dart';
import 'package:bloc_pattren_sample/views/photo_gallary_view.dart';
import 'package:bloc_pattren_sample/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = state.authError;
            if (authError != null) {
              showAuthErrorDialog(
                authError: authError,
                context: context,
              );
            }
          },
          builder: (context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginView();
            }
            if (state is AppStateLoggedIn) {
              return const PhotoGalleryView();
            }
            if (state is AppStateInRegistrationView) {
              return const RegisterView();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
