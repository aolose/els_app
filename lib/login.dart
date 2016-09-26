import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'service/util.dart';
import 'config.dart';

const double _kFlexibleSpaceMaxHeight = 256.0;
class LoginPage extends StatefulWidget {
  LoginPage({Key key,this.login}) : super(key: key);
  final  login;
  static const String routeName = '/login';
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<LoginPage> {
   String els,subEls,pwd,code;
  var codeImage;
  final Key _key = new ValueKey<String>("Els Login");
  resetCodeImg(){
    getImageFromUri(API.IDENTIFY_CODE_IMAGE).then((image){
      setState(()=>codeImage=image);
    });
  }

  tip(BuildContext c,msg){
    Scaffold.of(c).showSnackBar(new SnackBar(
      content: new Text(msg)
    ));
  }

  @override
  void initState() {
    super.initState();
    resetCodeImg();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      appBar: new AppBar(
        title: new Text('用户登录'),
        leading: new Icon(Icons.account_box)
      ),
      body: new Builder(builder: (BuildContext context){
        return new Block(children: [
          new Form(
            child: new Block(
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
                new Input(
                  hintText: '请输入您的ELS账号',
                  labelText: 'Els ID',
                  formField: new FormField<String>(
                    setter:  (String val) { els = val; }
                  )
                ),
                new Input(
                  hintText: '请输入您的ELS子账号',
                  labelText: 'Els SubID',
                  formField: new FormField<String>(
                    setter:  (String val) { subEls = val; }
                  )
                ),
                new Input(
                  hintText: '请输入您的密码',
                  labelText: 'Password',
                  hideText: true,
                  formField: new FormField<String>(
                    setter:  (String val) { pwd = val; }
                  )
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Flexible(
                      child: new Input(
                        hintText: '请输入您的验证码',
                        labelText: '验证码',
                        formField: new FormField<String>(
                          setter: (String val) { code = val; }
                        )
                      )
                    ),
                    new Flexible(
                        child: new Container(
                            margin: const EdgeInsets.only(top:10.0),
                            height: 50.0,
                            child:  new GestureDetector(
                              onTap:resetCodeImg,
                              child: new RawImage(
                                image:codeImage,
                                fit: ImageFit.contain,
                              )
                            )
                        )
                    )
                  ]
                ),
                new Container(
                  padding:const EdgeInsets.only(top:50.0),
                  child: new Center(child: new RaisedButton(
                    color:Colors.blue[400],
                    child: new Container(
                      width: 160.0,
                      child: new Center(
                        child: new Text('登陆',style: new TextStyle(color: Colors.white,fontSize:18.0))
                      )
                    ),
                    onPressed: (){
                      if(sessionId==null){
                        tip(context,'获取sessionId 失败！');
                      }else{
                        login(API.LOGIN, els,subEls,pwd,code).then((msg){
                          if(uid!=null){
                            config.login();
                          }else tip(context, msg['message']);
                        });
                      }
                    }
                  ))
                )
              ]
            )
          )]);
        })
      );
    }
  }
