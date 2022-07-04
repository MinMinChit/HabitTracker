class HabitsDataConstructor {
  HabitsDataConstructor({
    required this.challengeName,
    required this.category,
    required this.datetime,
  });

  final String challengeName;
  final String category;
  final String datetime;

  // CREATE TABLE $_tableName(
  // id INTEGER PRIMARY KEY,
  // ChallengeName TEXT,
  // Category TEXT,
  // DateTime TEXT);
  Map<String, dynamic> toMap() {
    return {
      'ChallengeName': challengeName,
      'Category': category,
      'DateTime': datetime,
    };
  }
}
