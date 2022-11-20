class BookInfo {
  int? id;
  String? book_author;
  String? book_title;
  String? book_description;
  String? book_thumbnail;
  String? book_content;
  String? created_at;

  BookInfo({
    this.id,
    this.book_content,
    this.book_title,
    this.book_description,
    this.created_at,
    this.book_thumbnail,
    this.book_author,
  });

  BookInfo.fromJson(Map json)
      : id = json['id'],
        book_author = json['book_author'],
        book_title = json['book_title'],
        book_description = json['book_description'],
        book_content = json['book_content'],
        book_thumbnail = json['book_thumbnail'],
        created_at = json['created_at'];

  Map toJson() {
    return {
      'id': id,
      'book_author': book_author,
      'book_title': book_title,
      'book_description': book_description,
      'book_content': book_content,
      'book_thumbnail': book_thumbnail,
      'created_at': created_at,
    };
  }
}
