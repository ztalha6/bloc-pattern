import 'dart:convert';
import 'dart:io';

import 'package:bloc_pattren_sample/bloc/bloc_actions.dart';
import 'package:bloc_pattren_sample/bloc/person.dart';
import 'package:bloc_pattren_sample/bloc/persons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as dev_tools show log;

extension Log on Object {
  void log() => dev_tools.log(toString());
}

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
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: const HomePage(),
      ),
    );
  }
}

Future<Iterable<Person>> getPerons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Example'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonBloc>().add(
                        LoadPersonAction(
                          url: PersonUrl.person1.urlString,
                          loader: getPerons,
                        ),
                      );
                },
                child: const Text('Load json 1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonBloc>().add(
                        LoadPersonAction(
                          url: PersonUrl.person2.urlString,
                          loader: getPerons,
                        ),
                      );
                },
                child: const Text('Load json 2'),
              ),
            ],
          ),
          BlocBuilder<PersonBloc, GetPersonResponse?>(
            buildWhen: (previousResult, currentResult) =>
                previousResult?.persons != currentResult?.persons,
            builder: (context, fetchResult) {
              fetchResult?.log();
              final persons = fetchResult?.persons;
              if (persons == null) return const SizedBox.shrink();
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (BuildContext context, int index) {
                    final person = persons[index]!;
                    return Text('${person.name}, ${persons[index]?.age}');
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
