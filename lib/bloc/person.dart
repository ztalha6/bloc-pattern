class Person {
  String? name;
  int? age;

  Person({this.name, this.age});

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
