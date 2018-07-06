//圆角方角转换
/*
new Scaffold(
 appBar: new AppBar(
 ...
actions: <Widget>[
  new IconButton(
    icon: const Icon(Icons.sentiment_very_satisfied),
    onPressed: () {
      setState(() {
        _shape = _shape != null ? null : const RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: const Radius.circular(2.0),
            bottomRight: const Radius.circular(2.0),
          ),
        );
      });
    },
  ),
],
...

*/

//底部样式效果转换
/*
new Scaffold(
  appBar: new AppBar(
  ...
  actions: <Widget>[
    new PopupMenuButton<BottomNavigationBarType>(
      onSelected: (BottomNavigationBarType value) {
        setState(() {
          _type = value;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<BottomNavigationBarType>>[
        const PopupMenuItem<BottomNavigationBarType>(
            value: BottomNavigationBarType.fixed,
            child: const Text('Fixed')
        ),
        const PopupMenuItem<BottomNavigationBarType>(
            value: BottomNavigationBarType.shifting,
            child: const Text('Shifting')
        )
      ],
    )
  ],
  ...

 */
