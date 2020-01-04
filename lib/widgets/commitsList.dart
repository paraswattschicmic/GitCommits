import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:GitCommits/modals/commitsModal.dart';
import 'package:GitCommits/services/webservice.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class CommitListState extends State<CommitsList> {
  List<Commits> _commits = List<Commits>();

  @override
  void initState() {
    super.initState();
    _getCommits();
  }

  _getCommits() {
    API.getCommits().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        _commits = list.map((model) => Commits.fromJson(model)).toList();
        print('_commits');
        print(_commits.length);
      });
    });
  }

  dispose() {
    super.dispose();
  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
        title:
            Text('Name: ' + _commits[index].commit.committer.name ?? 'Name: '));
  }

  Widget column = Expanded(
    child: Column(
      // align the text to the left instead of centered
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: TextStyle(fontSize: 16),
        ),
        Text('Email'),
        Text('Commit Time'),
        Text('Message'),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Git Commits History Flutter Demo'),
        ),
        body: ListView.separated(
          itemCount: _commits.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            return _buildItemsForListView(context, index);
          },
        ));
  }
}

class CommitsList extends StatefulWidget {
  @override
  createState() => CommitListState();
}
