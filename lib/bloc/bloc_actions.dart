import 'package:bloc_pattren_sample/bloc/person.dart';
import 'package:flutter/material.dart';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadPersonAction({
    required this.url,
    required this.loader,
  }) : super();
}

enum PersonUrl {
  person1('http://127.0.0.1:5500/api/persons1.json'),
  person2('http://127.0.0.1:5500/api/persons2.json');

  final String urlString;
  const PersonUrl(this.urlString);
}
