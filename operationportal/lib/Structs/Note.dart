class Note {
  int noteId;
  String author;
  String content;

  Note({this.noteId, this.author, this.content});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['noteId'],
      author: json['author'],
      content: json['content'],
    );
  }
}