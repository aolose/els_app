import 'package:flutter/material.dart';
class Tab {
  Tab({
    this.widget,
    this.tabName,
    this.icon
  });

  final Widget widget;
  final IconData icon;
  final String tabName;

  static Map<Tab, TabLabel> buildTabLabels(List<Tab> tabs) {
    return new Map<Tab, TabLabel>.fromIterable(
      tabs,
      value: (Tab t) => new TabLabel(
        text: t.tabName,
        icon: new Icon(t.icon)
      )
    );
  }

  @override
  bool operator==(Object other) {
    if (other.runtimeType != runtimeType)
    return false;
    Tab typedOther = other;
    return typedOther.tabName == tabName;
  }

  @override
  int get hashCode => tabName.hashCode;
}

class TabScaffold extends StatelessWidget {
  TabScaffold({
    this.title,
    this.tabs,
    this.drawer
  });

  final List<Tab> tabs;
  final String title;
  final Widget drawer;

  @override
  Widget build(BuildContext context) {
    return new TabBarSelection<Tab>(
      values: tabs,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('$title'),
          actions: <Widget>[
            new Builder(
              builder: (BuildContext context) {
                return new IconButton(
                  icon: new Icon(Icons.description),
                  tooltip: '',
                  onPressed: null
                );
              }
            )
          ],
          bottom: new TabBar<Tab>(
            isScrollable: true,
            labels: Tab.buildTabLabels(tabs)
          )
        ),
        drawer:drawer,
        body: new TabBarView<Tab>(
          children: tabs.map((Tab t) {
            return new Column(
              children: <Widget>[
                new Flexible(child: t.widget)
              ]
            );
          }).toList()
        )
      )
    );
  }
}
