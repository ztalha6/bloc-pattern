import 'package:bloc_pattren_sample/bloc/bloc_actions.dart';
import 'package:bloc_pattren_sample/bloc/person.dart';
import 'package:bloc_pattren_sample/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

List<Person> mockedPerson1 = [
  Person(
    name: 'Foo',
    age: 10,
  ),
  Person(
    name: 'Bar',
    age: 20,
  ),
];
List<Person> mockedPerson2 = [
  Person(
    name: 'Foo',
    age: 10,
  ),
  Person(
    name: 'Bar',
    age: 20,
  ),
];

Future<Iterable<Person>> mockedGetPerson1(String url) =>
    Future.value(mockedPerson1);

Future<Iterable<Person>> mockedGetPerson2(String url) =>
    Future.value(mockedPerson2);

void main() {
  group(
    'Testing bloc',
    () {
      // write the test
      late PersonBloc bloc;
      setUp(() {
        bloc = PersonBloc();
      });

      blocTest<PersonBloc, GetPersonResponse?>(
        'Testing inital state',
        build: () => bloc,
        verify: (bloc) => expect(bloc.state, null),
      );

      blocTest<PersonBloc, GetPersonResponse?>(
        'Mock retrieving persons from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonAction(
              url: 'dummy_url_1',
              loader: mockedGetPerson1,
            ),
          );
          bloc.add(
            const LoadPersonAction(
              url: 'dummy_url_1',
              loader: mockedGetPerson1,
            ),
          );
        },
        expect: () => [
          GetPersonResponse(
            persons: mockedPerson1,
            isRetrievedFromCache: false,
          ),
          GetPersonResponse(
            persons: mockedPerson1,
            isRetrievedFromCache: true,
          ),
        ],
      );
      blocTest<PersonBloc, GetPersonResponse?>(
        'Mock retrieving persons from second iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonAction(
              url: 'dummy_url_2',
              loader: mockedGetPerson2,
            ),
          );
          bloc.add(
            const LoadPersonAction(
              url: 'dummy_url_2',
              loader: mockedGetPerson2,
            ),
          );
        },
        expect: () => [
          GetPersonResponse(
            persons: mockedPerson2,
            isRetrievedFromCache: false,
          ),
          GetPersonResponse(
            persons: mockedPerson2,
            isRetrievedFromCache: true,
          ),
        ],
      );
    },
  );
}
