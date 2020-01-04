class Commits {
  Commit commit;

  Commits({this.commit});

  Commits.fromJson(Map json) : commit = Commit.fromJson(json['commit']);

  Map toJson() {
    return {'commit': commit};
  }
}

class Commit {
  Committer committer;
  String message;

  Commit({this.committer, this.message});

  Commit.fromJson(Map json)
      : committer = Committer.fromJson(json['committer']),
        message = json['message'];

  Map toJson() {
    return {'committer': committer, 'message': message};
  }
}

class Committer {
  String name;
  String email;
  String date;

  Committer({this.name, this.email, this.date});

  Committer.fromJson(Map json)
      : name = json['name'],
        email = json['email'],
        date = json['date'];

  Map toJson() {
    return {'name': name, 'email': email, 'date': date};
  }
}
