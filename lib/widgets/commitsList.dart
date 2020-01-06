import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:GitCommits/modals/commitsModal.dart';
import 'package:GitCommits/services/webservice.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:GitCommits/utils/constants.dart';

class CommitListState extends State<CommitsList> {
  final RefreshController _refreshController = RefreshController();

  List<Commits> _commits = List<Commits>();
  bool isLoading = false;
  String apiUrl = Constants.COMMITS_URL;
  String nextPageUrl = '';
  bool hasNextPage = false;
  @override
  void initState() {
    super.initState();
    _getCommits();
  }

  _getCommits() {
    setState(() {
      _commits.clear();
      isLoading = true;
    });
    API.getCommits(apiUrl).then((response) {
      String nextPage = response.headers['link'] != null
          ? response.headers['link'].split(',')[0].split(';')[0]
          : '';
      nextPage = nextPage != ''
          ? nextPage.substring(nextPage.indexOf("<") + 1, nextPage.indexOf(">"))
          : '';
      String findNextPage = response.headers['link'] != null
          ? response.headers['link'].split(',')[0].split(';')[1].split('=')[1]
          : '';
      findNextPage = findNextPage.replaceAll('"', '');
      setState(() {
        hasNextPage = findNextPage == "next" ? true : false;
        nextPageUrl = nextPage;
        isLoading = false;
        Iterable list = json.decode(response.body);
        _commits = list.map((model) => Commits.fromJson(model)).toList();
        _refreshController.refreshCompleted();
      });
    });
  }

  _loadMoreCommits() {
    if (hasNextPage) {
      API.getCommits(nextPageUrl).then((response) {
        String nextPage = response.headers['link'] != null
            ? response.headers['link'].split(',')[0].split(';')[0]
            : '';
        nextPage = nextPage != ''
            ? nextPage.substring(
                nextPage.indexOf("<") + 1, nextPage.indexOf(">"))
            : '';
        String findNextPage = response.headers['link'] != null
            ? response.headers['link'].split(',')[0].split(';')[1].split('=')[1]
            : '';
        findNextPage = findNextPage.replaceAll('"', '');
        setState(() {
          hasNextPage = findNextPage == "next" ? true : false;
          nextPageUrl = nextPage;
          isLoading = false;
          Iterable list = json.decode(response.body);
          _commits = new List<Commits>.from(_commits)
            ..addAll(list.map((model) => Commits.fromJson(model)).toList());
          _refreshController.refreshCompleted();
        });
      });
    }
  }

  dispose() {
    super.dispose();
  }

  static Text makeText(String name) {
    return Text(name, style: TextStyle(fontWeight: FontWeight.bold));
  }

  String getTimeAgo(String dateTime) {
    var currentDate = new DateTime.now();
    var date = DateTime.parse(dateTime).toLocal();
    if (date.year == currentDate.year) {
      if (date.month == currentDate.month) {
        if (date.day == currentDate.day) {
          if (date.hour == currentDate.hour) {
            if (date.minute == currentDate.minute) {
              return (currentDate.second - date.second).toString() +
                  " seconds ago";
            } else {
              return (currentDate.minute - date.minute).toString() +
                  " minutes ago";
            }
          } else {
            return (currentDate.hour - date.hour).toString() + " hours ago";
          }
        } else {
          return (currentDate.day - date.day).toString() + " days ago";
        }
      } else {
        return (currentDate.month - date.month).toString() + " months ago";
      }
    } else {
      return (currentDate.year - date.year).toString() + " years ago";
    }
  }

  Expanded makeHeaderColumn(BuildContext context, int index, String text) {
    return Expanded(
        flex: 30,
        child: Column(
          // align the text to the left instead of centered
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            makeText(text),
          ],
        ));
  }

  Expanded makeDataColumn(BuildContext context, int index, String text) {
    return Expanded(
        flex: 70,
        child: Column(
          // align the text to the left instead of centered
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(text),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Git Commits History Flutter Demo')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _getCommits,
              child: ListView.builder(
                itemCount: hasNextPage ? _commits.length + 1 : _commits.length,
                // separatorBuilder: (BuildContext context, int index) =>
                //     Divider(),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  return (index == _commits.length && hasNextPage)
                      ? Container(
                          child: FlatButton(
                            child: Text("Load More"),
                            onPressed: () {
                              _loadMoreCommits();
                            },
                          ),
                        )
                      : Card(
                          child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 100,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(

                                        // align the text to the left instead of centered
                                        children: <Widget>[
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                makeHeaderColumn(
                                                    context, index, 'Name'),
                                                makeDataColumn(
                                                    context,
                                                    index,
                                                    _commits[index]
                                                        .commit
                                                        .committer
                                                        .name)
                                              ]),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                makeHeaderColumn(
                                                    context, index, 'Email'),
                                                makeDataColumn(
                                                    context,
                                                    index,
                                                    _commits[index]
                                                        .commit
                                                        .committer
                                                        .email)
                                              ]),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                makeHeaderColumn(context, index,
                                                    'Commit Time'),
                                                makeDataColumn(
                                                    context,
                                                    index,
                                                    getTimeAgo(_commits[index]
                                                        .commit
                                                        .committer
                                                        .date))
                                              ]),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                makeHeaderColumn(
                                                    context, index, 'Message'),
                                                makeDataColumn(
                                                    context,
                                                    index,
                                                    _commits[index]
                                                        .commit
                                                        .message)
                                              ])
                                        ])))
                          ],
                        ));
                  // return _buildItemsForListView(context, index);
                },
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCommits,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class CommitsList extends StatefulWidget {
  @override
  createState() => CommitListState();
}
