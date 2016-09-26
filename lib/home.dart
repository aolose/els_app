import 'dart:io';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'service/util.dart';
import 'widgets/tabs.dart';
import 'widgets/order.dart';
import 'widgets/userCard.dart';
import 'config.dart';
import 'login.dart';
import 'startPage.dart';

String _host= 'cs.51qqt.com';
class Home extends StatefulWidget{
  static const routeName= Navigator.defaultRouteName;
  @override
  _HomeState createState()=> new _HomeState();
}

getPurchaseOrder(Map data)async{
  if(data!=null){
    var res = await clientPost(API.GET_PURCHASE_ORDER,ContentType.JSON,JSON.encode(data));
    var jsonStr = (await res.transform(UTF8.decoder).toList()).join();
    print(jsonStr);
    Map r = {};
    try{r=JSON.decode(jsonStr);}catch(e){}
    return r;
  }
}

getUserInfo()async{
  List result =[];
  var res = await clientGet(API.LOGIN_USER_INFO,ContentType.JSON);
  await for(var c in res.transform(UTF8.decoder)){result.add(c);}
  Map r={};
  try{
    r=JSON.decode(result.join());
  }catch(e){

  }
  return r;
}


class _BackgroundLayer {
  _BackgroundLayer({ int level, double parallax })
  : assetName = 'assets/appbar/appbar_background_layer$level.png',
  parallaxTween = new Tween<double>(begin: 0.0, end: parallax);
  final String assetName;
  final Tween<double> parallaxTween;
}


const double _kFlexibleSpaceMaxHeight = 256.0;

final List<_BackgroundLayer> _kBackgroundLayers = <_BackgroundLayer>[
  new _BackgroundLayer(level: 0, parallax: _kFlexibleSpaceMaxHeight),
  new _BackgroundLayer(level: 1, parallax: _kFlexibleSpaceMaxHeight),
  new _BackgroundLayer(level: 2, parallax: _kFlexibleSpaceMaxHeight / 2.0),
  new _BackgroundLayer(level: 3, parallax: _kFlexibleSpaceMaxHeight / 4.0),
  new _BackgroundLayer(level: 4, parallax: _kFlexibleSpaceMaxHeight / 2.0),
  new _BackgroundLayer(level: 5, parallax: _kFlexibleSpaceMaxHeight)
];

class _HomeState extends State<Home>{
  Map userInfo={};
  bool _loaded=false;
  List<Map<String,String>> orders=[];
  final GlobalKey<RefreshIndicatorState> _refreshKey = new GlobalKey<RefreshIndicatorState>();
  static final GlobalKey<ScrollableState> _scrollKey = new GlobalKey<ScrollableState>();

  Widget _buildDrawer(BuildContext context) {
    return new Drawer(
      child: new Flex(
        direction: Axis.vertical,
        children: <Widget>[
          new Container(
            height: 240.0,
            child: new Stack(
              children: _kBackgroundLayers.map((_BackgroundLayer layer) {
                return new Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: new Image.asset(
                    layer.assetName,
                    fit: ImageFit.cover,
                    height: _kFlexibleSpaceMaxHeight
                  )
                );
              }).toList()
            ),
          ),
          new Flexible(
            flex: 1,
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  bottom: 10.0,
                  left: 0.0,
                  right: 0.0,
                  child: new DrawerItem(
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.exit_to_app,color: Colors.black54),
                        new Text('退出账号',style: new TextStyle(fontSize: 16.0,color: Colors.black54))
                      ]),
                      onPressed: () {
                        logOut();
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      }
                    )
                  )
                ]
              )
            )
          ]
        )
      );
    }

    _initOrderList()async{
      return getPurchaseOrder({
        'elsAccount':API.elsAccount,
        'elsSubAccount':API.elsSubAccount
      }).then((u){
        if(u!=null&&u['rows']!=null)
        setState(()=>orders=u['rows']);
      });
    }

    void _init(){
      if(_loaded){
        if(uid!=null){
          _initOrderList();
          getUserInfo().then((u){
            print('$sessionId,$uid,$u');
            print(u);
            setState((){
              userInfo=u;
            });
          });
        }else setState((){});
      }
    }

    @override
    void initState() {
      super.initState();
      _init();
    }
    @override
    Widget build(BuildContext context){
      if(!_loaded){
        return new StartPage(
          loading: loadLogin(),
          done:(){
            _loaded=true;
            _init();
          },
          child: new Image.asset('assets/1.jpg',fit: ImageFit.cover)
        );
      }
      if(uid==null){
        print('$sessionId,$uid');
        return new LoginPage(login:_init);
      }
      Iterable<Widget> listItems = orders.map((d)=>new OrderListItem(
        data: d,
        onTap: (){
          List<Widget> r=[];
          d.forEach((k,v){
            r.add(new Row(
              children:<Widget>[
                new Flexible(
                  flex: 1,
                  child: new Text('$k : ',style: new TextStyle(fontSize:18.0,color: Colors.black))
                ),
                new Flexible(
                  flex: 1,
                  child: new Text('$v',style: new TextStyle(fontSize:13.0,color: Colors.black))
                )
              ]
            ));
            r.add(new Divider(color: Colors.grey[200]));
          });
          showDialog(
            context: context,
            child: new Container(
              decoration: new BoxDecoration(
                backgroundColor: Colors.white,
              ),
              margin: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 150.0),
              padding: const EdgeInsets.all(10.0),
              child: new Stack(
                children: [
                  new Positioned(
                    left: 0.0,right: 0.0,top:0.0,height: 50.0,
                    child: new Text(
                      '订单数据',
                      style:new TextStyle(
                        color: Colors.deepOrange[500],
                        fontSize: 20.0
                      ))
                  ),
                  new Positioned(
                    top:50.0,left: 0.0,right: 0.0,bottom: 10.0,
                    child: new Block(
                      children: r
                    )
                  )
                ]
              )
            )
          );
        }
      ));
      Container info = new Container(
        margin: const EdgeInsets.all(20.0),
        child: new UserCard(info: userInfo)
      );

      List<Tab> tabs = <Tab>[
        new Tab(
          tabName:'个人信息',
          icon: Icons.account_box,
          widget: info
        ),
        new Tab(
          tabName:'单据列表',
          icon: Icons.collections_bookmark,
          widget:new RefreshIndicator(
            key: _refreshKey,
            scrollableKey: _scrollKey,
            refresh: _initOrderList,
            child:   new MaterialList(
              scrollableKey: _scrollKey,
              children: listItems
            )
          )
        ),
        new Tab(
          tabName:'其他',
          icon: Icons.add,
          widget: new Container()
        )
      ];

      return  new TabScaffold(
        title: userInfo['companyShortName'],
        tabs: tabs,
        drawer: _buildDrawer(context)
      );
    }
  }
