import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:GitCommits/widgets/commitsList.dart';

void main() => runApp(CommitsApp());

class CommitsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Commits", home: CommitsList());
  }
}
