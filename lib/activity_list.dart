// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:convert';

import 'package:banquet_meeter/activity_detail.dart';
import 'package:banquet_meeter/entity/person.dart';
import 'package:banquet_meeter/material/search_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

Future<List<Person>> fetchPersons(http.Client client) async {
  final response =
  await client.get('http://10.4.244.185:8080/person?lastName=Chen');

  return compute(parsePersons, response.body);
}

List<Person> parsePersons(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Person>((json)=> Person.fromJson(json)).toList();
}

//构建活动卡片
class PersonItem extends StatelessWidget {
  PersonItem({ Key key, @required this.person, this.shape })
      : assert(person != null && person.isValid),
        super(key: key);

  static const double height = 366.0;
  final Person person;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return new SafeArea(
      top: false,
      bottom: false,
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        height: height,
        child: new Card(
          shape: shape,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // photo and title
              new SizedBox(
                height: 184.0,
                child: new Stack(
                  children: <Widget>[
                    new Positioned.fill(
                      child: new Image.asset(
                        person.avatar,
                        package: _kGalleryAssetsPackage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    new Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: new FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: new Text(person.label,
                          style: titleStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // description and share/explore buttons
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: new DefaultTextStyle(
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: descriptionStyle,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // three line description
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: new Text(
                            person.lastName + '-' + person.firstName,
                            style: descriptionStyle.copyWith(color: Colors.black54),
                          ),
                        ),
                        new Text(person.gender),
                        new Text(person.age.toString()),
                      ],
                    ),
                  ),
                ),
              ),
              // share, explore buttons
              new ButtonTheme.bar(
                child: new ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new FlatButton(
                      child: const Text('DETAIL'),
                      textColor: Colors.amber.shade500,
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ActivityDetail(person: person,))
                        );
                      },
                    ),
                    new FlatButton(
                      child: const Text('EXPLORE'),
                      textColor: Colors.amber.shade500,
                      onPressed: () { /* do nothing */ },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(
  new MaterialApp(
    title: 'My app',
    home: new CardsDemo(),
  ),
);

class CardsDemo extends StatefulWidget {

  @override
  _CardsDemoState createState() => new _CardsDemoState();
}

class _CardsDemoState extends State<CardsDemo> {
  ShapeBorder _shape;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SearchDemoSearchDelegate _delegate = new SearchDemoSearchDelegate();

  int _lastIntegerSelected;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
//        title: const Text('活动页'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () async {
                final int selected = await showSearch<int>(
                    context: context,
                    delegate: _delegate
                );
                if (selected != null && selected != _lastIntegerSelected) {
                  setState(() {
                    _lastIntegerSelected = selected;
                  });
                }
              }
          ),
          new IconButton(
              tooltip: 'More (not implemented)',
              icon: const Icon(Icons.more_vert),
              onPressed: () {}
          )
        ],
      ),
      body: FutureBuilder<List<Person>>(
        future: fetchPersons(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? PersonsList(persons: snapshot.data, shape: _shape)
              : Center(child: new CircularProgressIndicator());
        }
      ),
//        bottomNavigationBar: botNavBar,
    );
  }
}

class PersonsList extends StatelessWidget {
  final List<Person> persons;
  final ShapeBorder shape;

  PersonsList({Key key, this.persons, this.shape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemExtent: PersonItem.height,
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      itemCount: persons.length,
      itemBuilder: (context, index) {
        return new PersonItem(person: persons[index], shape: shape);
      },
    );
  }

}