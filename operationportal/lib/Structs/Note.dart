class Note {
  int noteId;
  String author;
  String content;
  DateTime date;

  Note({this.noteId, this.author, this.content, this.date});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['noteId'],
      author: json['author'],
      content: json['content'],
      date: json['date'] != null ?
      new DateTime(int.parse(json['date'].split('-')[0]),
          int.parse(json['date'].split('-')[1]),
          int.parse(json['date'].split('-')[2].split('T')[0])) : null,
    );
  }
}