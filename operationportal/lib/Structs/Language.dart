class Language {
  String name;

  Language({this.name});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'],
    );
  }
}