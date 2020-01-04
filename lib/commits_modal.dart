import 'dart:convert';
import 'dart:io';

class Commits {
  final String name;
  final String email;
  final String commitTime;
  final String message;

  Commits(this.name, this.email, this.commitTime, this.message);
  Future getComits() async {
    // Null check so our app isn't doing extra work.
    // If there's already an image, we don't need to get one.

    // This is how http calls are done in flutter:
    HttpClient http = HttpClient();
    try {
      // Use darts Uri builder
      var uri = Uri.http('https://api.github.com/',
          'repos/paraswattschicmic/GitCommits/commits?page=1&per_page=10');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      // The dog.ceo API returns a JSON object with a property
      // called 'message', which actually is the URL.
      print(json.decode(responseBody));
    } catch (exception) {
      print(exception);
    }
  }
}
