import 'package:bloc_pattren_sample/bloc/app_bloc.dart';
import 'package:bloc_pattren_sample/extensions/stream/start_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({super.key});

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextImageEvent(),
    ).startWith(const LoadNextImageEvent()).forEach((event) {
      context.read<T>().add(event); 
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, appState) {
          if (appState.error != null) {
            return Text('Error: ${appState.error}');
          }
          if (appState.data != null) {
            return Image.memory(
              appState.data!,
              fit: BoxFit.fitHeight,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
