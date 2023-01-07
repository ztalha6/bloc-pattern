import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devTools show log;

extension Log on Object {
  void log() => devTools.log(toString());
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

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final PersonUrl url;
  const LoadPersonAction(this.url) : super();
}

enum PersonUrl {
  person1("http://127.0.0.1:5500/api/persons1.json"),
  person2("http://127.0.0.1:5500/api/persons2.json");

  final String urlString;
  const PersonUrl(this.urlString);
}

class Person {
  String? name;
  int? age;

  Person({required this.name, required this.age});

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['age'] = age;
    return data;
  }

  @override
  String toString() => 'Person (name=$name, age=$age)';
}

Future<Iterable<Person>> getPerons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

class GetPersonResponse {
  Iterable<Person> persons;
  bool isRetrievedFromCache;

  GetPersonResponse(
      {required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() =>
      "GetPersonResponse (isRetrievedFromCache = $isRetrievedFromCache, person = $persons)";
}

class PersonBloc extends Bloc<LoadAction, GetPersonResponse?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        // we have value in cache
        final cachePersons = _cache[url]!;
        final result = GetPersonResponse(
          persons: cachePersons,
          isRetrievedFromCache: true,
        );
        emit(result);
      } else {
        final persons = await getPerons(url.urlString);
        _cache[url] = persons;
        final result = GetPersonResponse(
          persons: persons,
          isRetrievedFromCache: false,
        );
        emit(result);
      }
    });
  }
}

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
                        const LoadPersonAction(PersonUrl.person1),
                      );
                },
                child: const Text('Load json 1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonBloc>().add(
                        const LoadPersonAction(PersonUrl.person2),
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
