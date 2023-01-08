import 'package:bloc_pattren_sample/bloc/bloc_actions.dart';
import 'package:bloc_pattren_sample/bloc/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension IsEqualToIgnoringOrder<T> on Iterable<T> {
  bool isEqualToIgnoringOrder(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

@immutable
class GetPersonResponse {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const GetPersonResponse(
      {required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() =>
      'GetPersonResponse (isRetrievedFromCache = $isRetrievedFromCache, person = $persons)';

  @override
  bool operator ==(covariant GetPersonResponse other) =>
      persons.isEqualToIgnoringOrder(other.persons) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrievedFromCache);
}

class PersonBloc extends Bloc<LoadAction, GetPersonResponse?> {
  final Map<String, Iterable<Person>> _cache = {};
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
        final loader = event.loader;
        final persons = await loader(url);
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
