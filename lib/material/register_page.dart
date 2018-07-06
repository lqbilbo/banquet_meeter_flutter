// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'register_dialog.dart';

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}

const String _alertWithoutTitleText = 'Discard draft?';

const String _alertWithTitleText =
  'Let Google help apps determine location. This means sending anonymous location '
  'data to Google, even when no apps are running.';

class DialogDemoItem extends StatelessWidget {
  const DialogDemoItem({ Key key, this.icon, this.color, this.text, this.onPressed }) : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new SimpleDialogOption(
      onPressed: onPressed,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Icon(icon, size: 36.0, color: color),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Text(text),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(new MaterialApp(
  title: 'MyApp',
  home: new DialogDemo(),
));

class DialogDemo extends StatefulWidget {
  static const String routeName = '/material/dialog';

  @override
  DialogDemoState createState() => new DialogDemoState();
}

class DialogDemoState extends State<DialogDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    final DateTime now = new DateTime.now();
    _selectedTime = new TimeOfDay(hour: now.hour, minute: now.minute);
  }

  void showDemoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    )
    .then<void>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text('You selected: $value')
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('注册／登录')
      ),
      body: new ListView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 72.0),
        children: <Widget>[
          new RaisedButton(
            child: const Text('权益声明'),
            onPressed: () {
              showDemoDialog<DialogDemoAction>(
                context: context,
                child: new AlertDialog(
                  title: const Text('Use Banquet Meeter\'s location service?'),
                  content: new Text(
                    _alertWithTitleText,
                    style: dialogTextStyle
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: const Text('不同意'),
                      onPressed: () { Navigator.pop(context, DialogDemoAction.disagree); }
                    ),
                    new FlatButton(
                      child: const Text('同意'),
                      onPressed: () { Navigator.pop(context, DialogDemoAction.agree); }
                    )
                  ]
                )
              );
            }
          ),
          new RaisedButton(
            child: const Text('注册'),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
                builder: (BuildContext context) => new FullScreenDialogDemo(),
                fullscreenDialog: true,
              ));
            }
          ),
          new RaisedButton(
              child: const Text('登录'),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
                  builder: (BuildContext context) => new FullScreenDialogDemo(),
                  fullscreenDialog: true,
                ));
              }
          ),
        ]
        // Add a little space between the buttons
        .map((Widget button) {
          return new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: button
          );
        })
        .toList()
      )
    );
  }
}
