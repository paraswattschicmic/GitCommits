import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:GitCommits/modals/commitsModal.dart';
import 'package:GitCommits/services/webservice.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommitListState extends State<CommitsList> {
  final RefreshController _refreshController = RefreshController();

  List<Commits> _commits = List<Commits>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _getCommits();
    print(new DateTime.now());
  }

  _getCommits() {
    print("inside get commits");
    setState(() {
      _commits.clear();
      isLoading = true;
    });
    API.getCommits().then((response) {
      setState(() {
        isLoading = false;
        Iterable list = json.decode(response.body);
        _commits = list.map((model) => Commits.fromJson(model)).toList();
        _refreshController.refreshCompleted();
        print('_commits');
        print(_commits.length);
      });
    });
  }

  dispose() {
    super.dispose();
  }

  String getTimeAgo(String dateTime) {
    var currentDate = new DateTime.now();
    var date = DateTime.parse(dateTime);
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

  static Text makeText(String name) {
    return Text(name, style: TextStyle(fontWeight: FontWeight.bold));
  }

  DataRow dataCell(Commits obj) {
    print(obj);
    return DataRow(cells: <DataCell>[
      DataCell(Text(obj.commit.committer.name)),
      DataCell(Text(obj.commit.committer.email)),
      DataCell(Text(obj.commit.committer.date)),
      DataCell(Text(obj.commit.message))
    ]);
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
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: [
                            DataColumn(label: makeText("Name")),
                            DataColumn(label: makeText("Email")),
                            DataColumn(label: makeText("Commit Time")),
                            DataColumn(label: makeText("Message"))
                          ],
                          rows: _commits
                              .map((obj) => DataRow(cells: <DataCell>[
                                    DataCell(Text(obj.commit.committer.name)),
                                    DataCell(Text(obj.commit.committer.email)),
                                    DataCell(Text(
                                        getTimeAgo(obj.commit.committer.date))),
                                    DataCell(Text(obj.commit.message))
                                  ]))
                              .toList())))),
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
