class Person {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final int age;
  final String label;
  final String avatar;

  Person({this.id, this.firstName, this.lastName, this.gender, this.age, this.label, this.avatar });

  factory Person.fromJson(Map<String, dynamic> json) {
    return new Person(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        age: json['age'],
        label: json['label'],
        avatar: json['avatar']
    );
  }

  bool get isValid => avatar != null && label != null;
}
