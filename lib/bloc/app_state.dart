// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_pattren_sample/models.dart';
import 'package:collection/collection.dart';

class AppState {
  final bool isLoading;
  final LoginError? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;

  const AppState({
    required this.isLoading,
    this.loginError,
    this.loginHandle,
    this.fetchedNotes,
  });

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginError': loginError,
        'loginHandle': loginHandle,
        'fetchedNotes': fetchedNotes
      }.toString();

  @override
  bool operator ==(covariant AppState other) {
    final otherPropertiesAreEqual = isLoading == other.isLoading &&
        loginHandle == other.loginHandle &&
        loginError == other.loginError;

    if (fetchedNotes == null && other.fetchedNotes == null) {
      return otherPropertiesAreEqual;
    }
    return otherPropertiesAreEqual &&
        (fetchedNotes?.isEqualTo(other.fetchedNotes) ?? true);
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        loginHandle,
        loginError,
        fetchedNotes,
      );
}

extension UnorderedEquality on Object {
  bool isEqualTo(other) =>
      const DeepCollectionEquality.unordered().equals(this, other);
}
