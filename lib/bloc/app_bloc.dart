import 'dart:io';

import 'package:bloc_pattren_sample/auth/auth_errors.dart';
import 'package:bloc_pattren_sample/bloc/app_events.dart';
import 'package:bloc_pattren_sample/bloc/app_state.dart';
import 'package:bloc_pattren_sample/utils/image_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut()) {
    // app state initialize
    on<AppEventInitialize>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // loggout if we don't have user is app state
        if (user == null) {
          emit(const AppStateLoggedOut());
          return;
        }
        final images = await _getIamges(user.uid);
        emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ));
      },
    );

    // handle registations
    on<AppEventRegister>(
      (event, emit) async {
        // start loading
        emit(const AppStateInRegistrationView(isLoading: true));
        final email = event.email;
        final password = event.password;
        try {
          final credentials =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // emiting logged in state
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: credentials.user!,
              images: const [],
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventGoToLogin>((event, emit) {
      emit(const AppStateLoggedOut());
    });

    on<AppEventGoToRegistration>((event, emit) {
      emit(const AppStateInRegistrationView());
    });

    // handle login
    on<AppEventLogin>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      // log the user in
      final email = event.email;
      final password = event.password;

      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final images = await _getIamges(userCredential.user!.uid);

        emit(AppStateLoggedIn(
          isLoading: false,
          user: userCredential.user!,
          images: images,
        ));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    // handle upload image
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        // loggout if we don't have user is app state
        if (user == null) {
          emit(const AppStateLoggedOut());
          return;
        }

        //start loading
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        // uploading the file
        final file = File(event.filePathToUpload);
        await uploadImage(file: file, userId: user.uid);

        //after uploaded grab the latest file list
        final images = await _getIamges(user.uid);

        // emit the new iamges and turn off loading
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );

    // handle accout deletion
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // loggout if we don't have user is app state
        if (user == null) {
          emit(const AppStateLoggedOut());
          return;
        }

        //start loading
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        try {
          //delete the user folder
          final folderContents =
              await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folderContents.items) {
            await item.delete().catchError((_) {});
          }

          //delete the folder itself
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          // delete the user
          await user.delete();

          // signed the user out
          await FirebaseAuth.instance.signOut();
          emit(const AppStateLoggedOut());
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: state.images ?? [],
              authError: AuthError.from(e),
            ),
          );
          return;
        } on FirebaseException {
          // we might not be able to delete the user folder
          // log the user out
          emit(const AppStateLoggedOut());
        }
      },
    );

    // handle logout
    on<AppEventLogout>((event, emit) async {
      // start loading
      emit(const AppStateLoggedOut(isLoading: true));

      // signed the user out
      await FirebaseAuth.instance.signOut();
      emit(const AppStateLoggedOut());
    });
  }

  Future<Iterable<Reference>> _getIamges(String userId) async =>
      (await FirebaseStorage.instance.ref(userId).list()).items;
}
