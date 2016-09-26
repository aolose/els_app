import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class StartPage extends StatefulWidget{
  StartPage({Key key,this.child,this.loading,this.done}):super(key:key);
  final Widget child;
  final Future loading;
  final VoidCallback done;

  @override
  _StartPageState createState()=>new _StartPageState();
}

class _StartPageState extends State<StartPage>{
  double opacity=0.0;
  var t = new Duration(milliseconds: 300);
  void setOpacity(double o){
    setState(()=>opacity=o);
  }
  void fadeOut(){
    new Future<Null>.delayed(t*2).whenComplete((){
      setOpacity(0.0);
      new Future<Null>.delayed(t).whenComplete(config.done);
    });
  }
  @override
  void initState(){
    super.initState();
    int state=0;
    new Future.delayed(t).whenComplete((){
      setOpacity(1.0);
      if(2==++state)fadeOut();
    });
    config.loading.whenComplete((){
      if(2==++state)fadeOut();
    });
  }
  @override
  Widget build(BuildContext content){
    return new DecoratedBox(
      decoration:new BoxDecoration(
        backgroundColor: Colors.white,
      ),
      child:
      new AnimatedOpacity(
        duration: new Duration(milliseconds: 300),
        opacity: opacity,
        child: new Center(
          child: config.child
        )
      )
    );
  }
}
