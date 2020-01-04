import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:GitCommits/modals/commitsModal.dart';
import 'package:GitCommits/services/webservice.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommitListState extends State<CommitsList> {
  final RefreshController _refreshController = RefreshController();

  List<Commits> _commits = List<Commits>();

  @override
  void initState() {
    super.initState();
    _getCommits();
  }

  _getCommits() {
    print("inside get commits");
    setState(() {
      _commits.clear();
    });
    API.getCommits().then((response) {
      setState(() {
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

  Widget dataColumn(BuildContext context, int index) {
    return Expanded(
        child: Column(
      // align the text to the left instead of centered
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_commits[index].commit.committer.name),
        Text(_commits[index].commit.committer.email),
        Text(_commits[index].commit.committer.date),
        Text(_commits[index].commit.message),
      ],
    ));
  }

  static Text makeText(String name) {
    return Text(name, style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget headingColumn = Expanded(
    child: Column(
      // align the text to the left instead of centered
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        makeText('Name'),
        makeText('Email'),
        makeText('Commit Time'),
        makeText('Message'),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Git Commits History Flutter Demo')),
      body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _getCommits,
          child: ListView.separated(
            itemCount: _commits.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: <Widget>[headingColumn, dataColumn(context, index)],
              );

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
