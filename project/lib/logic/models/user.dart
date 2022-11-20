class User {
  int? id;
  String? name;
  String? email;
  String? imagePath;

  User({
    this.id,
    this.name,
    this.email,
    this.imagePath,
  });
  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        imagePath = json['imagepath'],
        email = json['email'];
  Map toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imagepath': imagePath,
    };
  }
}
