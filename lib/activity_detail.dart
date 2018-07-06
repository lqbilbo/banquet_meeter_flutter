import 'package:banquet_meeter/entity/person.dart';
import 'package:flutter/material.dart';

class ActivityDetail extends StatelessWidget {
  final Person person;

  ActivityDetail({Key key, @required this.person}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('${person.label}'),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Text('${person.label}')
      )
    );
  }
}