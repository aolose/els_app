import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/util.dart';
import '../config.dart';
import 'dart:ui' as Ui;

class _Info extends StatelessWidget{
  _Info(this.label,this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext c){
    return new Flexible(
      flex: 1,
      child: new Column(
        children: [
          new Container(height: 10.0),
          new Center(child:
            new Text('$label',style: new TextStyle(color:Colors.white.withOpacity(0.7),fontSize: 13.0)),
          ),
          new Center(child:
            new Text('$value',style: new TextStyle(color:Colors.white.withOpacity(0.8),fontSize: 14.0))
          )
        ]
      )
    );
  }
}

class UserCard extends StatefulWidget{
  UserCard({Key key,this.info}):super(key:key);
  final Map info;

  @override
  _UserCard createState()=>new _UserCard();
}

class _UserCard extends State<UserCard>{
  Ui.Image imageData;
  @override
  void initState(){
    super.initState();
    getImageFromUri(new Uri.http(API.sysHost, '${API.stroagePath}/${config.info['logo']}'),false)
    .then((image)=>setState(()=>imageData=image));
  }
  @override
  Widget build(BuildContext content){
    return new Container(
      margin: const EdgeInsets.all(15.0),
      child: new Card(
        elevation:6,
        child: new Column(
          children: <Widget>[
            new Flexible(
              flex: 1,
              child: new Container(
                decoration: new BoxDecoration(
                  backgroundImage: new BackgroundImage(
                    image:  new AssetImage('assets/user_card_bg.jpg'),
                    fit: ImageFit.cover
                  )),
                  child: new Stack(
                    children: [
                      new Positioned(
                        bottom: 30.0,
                        left: 0.0,
                        right: 0.0,
                        top: 30.0,
                        child: new Center(
                          child: new Container(
                            height: 250.0,
                            child: new Column(
                              children: [
                                new ClipOval(child: new RawImage(
                                  image: imageData,
                                  width: 84.0,
                                  height: 84.0,
                                  fit: ImageFit.cover
                                )),
                                new Container(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: new Column(
                                    children: [
                                      new Center(child:
                                        new Text('${config.info['name']}',style: new TextStyle(color:Colors.white.withOpacity(0.9),fontSize: 24.0)),
                                      ),
                                      new Center(child:
                                        new Text('${config.info['companyShortName']}',style: new TextStyle(color:Colors.white.withOpacity(0.8),fontSize: 18.0)),
                                      )
                                    ]
                                  )
                                )
                              ]
                            )
                          )
                        )
                      ),
                      new Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: new Container(
                          height: 50.0,
                          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: new Center(
                            child: new Row(
                              children: [
                                new _Info('账号','${config.info['elsAccount']}'),
                                new Container(width: 1.0,margin :const EdgeInsets.only(left: 5.0,right: 5.0), decoration:new BoxDecoration(border: new Border(left: new BorderSide(color: Colors.white.withOpacity(0.5))))),
                                new _Info('子账号','${config.info['elsSubAccount']}'),
                                new Container(width: 1.0,margin :const EdgeInsets.only(left: 5.0,right: 5.0), decoration:new BoxDecoration(border: new Border(left: new BorderSide(color: Colors.white.withOpacity(0.5))))),
                                new _Info('角色','${config.info['roleName']}')
                              ]
                            )
                          )
                        )
                      )
                    ]
                  )
                )
              ),
              new Container(
                height: 50.0,
                decoration: new BoxDecoration(
                  backgroundColor: Colors.blueGrey[700]
                ),
                child: new Center(
                  child: new Text('资料卡片',style: new TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16.0
                  ))
                )
              )
            ]
          ))
        );
      }
    }
