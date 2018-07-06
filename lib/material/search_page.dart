import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
  title: 'MyApp',
  home: new SearchDemo(),
));

//运行时
class SearchDemo extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SearchDemoState();
}

class _SearchDemoState extends State<SearchDemo> {
  final SearchDemoSearchDelegate _delegate = new SearchDemoSearchDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _lastIntegerSelected;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        leading: new IconButton(
            tooltip: 'Navigation Menu',
            icon: new AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              color: Colors.white,
              progress: _delegate.transitionAnimation,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }
        ),
        title: const Text('Numbers'),
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
      body: new Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new MergeSemantics(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            const Text('Press the '),
                            const Tooltip(
                                message: 'search',
                                child: const Icon(
                                    Icons.search,
                                    size: 18.0
                                )
                            ),
                            const Text(' icon in the AppBar')
                          ]
                      ),
                      const Text(
                          'and search for an integer between 0 and 100,000.')
                    ],
                  )
              ),
              const SizedBox(height: 64.0),
              new Text(
                  'Last selected integer: ${_lastIntegerSelected ?? 'NONE' }.')
            ]
        ),
      ),
      floatingActionButton: new FloatingActionButton.extended(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
          label: const Text('Close Demo')
      ),
    );
  }
}

//搜索代理类
class SearchDemoSearchDelegate extends SearchDelegate<int> {
  final List<int> _data = new List<int>.generate(100001, (int i) => i).reversed
      .toList();
  final List<int> _history = <int>[40607, 85604, 66374, 44, 174]; //历史搜索记录

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: new AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final Iterable<int> suggestions = query.isEmpty
        ? _history
        : _data.where((int i) => '$i'.startsWith(query));

    return new _SuggestionList(
      query: query,
      suggestions: suggestions.map((int i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final int searched = int.tryParse(query);
    if (searched == null || !_data.contains(searched)) {
      return new Center(
        child: new Text(
          '"$query"\n is not a valid integer between 0 and 100,000.\nTry again.',
          textAlign: TextAlign.center
        ),
      );
    }

    return new ListView(
      children: <Widget>[
        new _ResultCard(
          title: 'This integer',
          integer: searched,
          searchDelegate: this,
        ),
        new _ResultCard(
          title: 'Next integer',
          integer: searched + 1,
          searchDelegate: this,
        ),
        new _ResultCard(
          title: 'Previous integer',
          integer: searched - 1,
          searchDelegate: this,
        )
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
        ? new IconButton(
          tooltip: 'Voice Search',
          icon: const Icon(Icons.mic),
          onPressed: () {
            query = 'TODO: implement voice input';
          }
        )
        : new IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          }
        )
    ];
  }
}

//构建搜索推荐列
class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return new ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: new RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                new TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead
                )
              ]
            )
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      }
    );
  }
}

//构建搜索结果卡片
class _ResultCard extends StatelessWidget {
  const _ResultCard({this.integer, this.title, this.searchDelegate});

  final int integer;
  final String title;
  final SearchDelegate<int> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new GestureDetector(
      onTap: () {
        searchDelegate.close(context, integer);
      },
      child: new Card(
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              new Text(title),
              new Text(
                '$integer',
                style: theme.textTheme.headline.copyWith(fontSize: 72.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}