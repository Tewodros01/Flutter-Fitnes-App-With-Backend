class WorkoutInfo {
  int? id;
  String? workout_author;
  String? workout_title;
  String? workout_description;
  String? workout_thumbnail;
  String? workout_content;
  WorkoutInfo({
    this.id,
    this.workout_author,
    this.workout_title,
    this.workout_description,
    this.workout_thumbnail,
    this.workout_content,
  });
  WorkoutInfo.fromJson(Map json)
      : id = json['id'],
        workout_author = json['workout_author'],
        workout_title = json['workout_title'],
        workout_description = json['workout_description'],
        workout_thumbnail = json['workout_thumbnail'],
        workout_content = json['workout_content'];

  Map toJson() {
    return {
      'id': id,
      'workout_author': workout_author,
      'workout_title': workout_title,
      'workout_description': workout_description,
      'workout_thumbnail': workout_thumbnail,
      'workout_content': workout_content,
    };
  }
}
