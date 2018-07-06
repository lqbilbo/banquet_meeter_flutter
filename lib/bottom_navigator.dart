import 'package:banquet_meeter/material/register_dialog.dart';
import 'package:banquet_meeter/material/register_page.dart';
import 'package:banquet_meeter/message_list.dart';
import 'package:banquet_meeter/order_list.dart';
import 'package:flutter/material.dart';
import 'package:banquet_meeter/person_info.dart';
import 'package:banquet_meeter/activity_list.dart';

//底部导航图标构建类
class NavigationIconView {
  NavigationIconView({
    Widget icon,
    String title,
    Color color,
    TickerProvider vsync,
    Widget screen
  }) : _icon = icon,
       _screen = screen,
       _color = color,
       _title = title,
       item = new BottomNavigationBarItem(
           icon: icon, 
           title: new Text(title),
           backgroundColor: color
       ),
       controller = new AnimationController(
           duration: kThemeAnimationDuration,
           vsync: vsync
       ) {
    _animation = new CurvedAnimation(
        parent: controller, 
        curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)
    );
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;
  final Widget _screen;

  //转场
  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 0.02),
            end: Offset.zero
          ).animate(_animation),
        child:
          new Container(
            child: _screen
          )
          /*new IconTheme(
            data: new IconThemeData(
                color: iconColor,
                size: 120.0
            ),
            child: new Semantics(
              label: 'Placeholder for $_title tab',
              child: _icon,
            )
          ),*/
      ),
    );
  }
}

//自定义图标属性
class CustomIcon extends StatelessWidget {
  final Widget _icon;

  CustomIcon({Key key, Widget icon}) : _icon = icon;

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new IconButton(
      color: iconTheme.color,
      icon: const Icon(Icons.person),
      onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new ContactsDemo()));
      }
    );
  }
}

/***************************运行时开始*******************************************/

class BottomNavigationDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo>
  with TickerProviderStateMixin {

  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;

  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.access_alarm),
        title: '活动',
        color: Colors.deepPurple,
        vsync: this,
        screen: new CardsDemo()
      ),
      new NavigationIconView(
        icon: const Icon(Icons.description),
        title: '订单',
        color: Colors.red,
        vsync: this,
        screen: new OrdersDemo()
      ),
      new NavigationIconView(
        icon: const Icon(Icons.add_circle),
        title: '发布',
        color: Colors.orange,
        vsync: this,
        screen: new FullScreenDialogDemo()
      ),
      new NavigationIconView(
        icon: const Icon(Icons.message),
        title: '信息',
        color: Colors.green,
        vsync: this,
        screen: new ListDemo()
      ),
      new NavigationIconView(
        icon: const Icon(Icons.person),
        title: '我',
        color: Colors.lightBlue,
        vsync: this,
        screen: selectedScreen()
      )
    ];

    for(NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  Widget selectedScreen() {
    if(isLogin) {
      return new ContactsDemo();
    }
    return new DialogDemo();
  }

  void _rebuild() {
    setState(() {

    });
  }

  @override
  void dispose() {
    for(NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  //构建转换队列
  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for(NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    //底部导航栏
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
            .map((NavigationIconView navigationView) => navigationView.item)
            .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      body: new Center(
        child: _buildTransitionsStack(),
      ),
      bottomNavigationBar: botNavBar
    );
  }
}

void main() => runApp(new MaterialApp(
  title: 'My App',
  home: new BottomNavigationDemo(),
));

