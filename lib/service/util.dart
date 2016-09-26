import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import '../config.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';

final String userInfoFileName = '.uif';

Cookie uid;
Cookie sessionId;
get _cookies{
  List<Cookie> c=[];
  if(sessionId!=null){
    c.add(sessionId);
    if(uid!=null)c.add(uid);
  }
  return c;
}

loadLogin()async{
  String cookies = await readStrFromFile(userInfoFileName);
  if(cookies!=null){
    Map c =JSON.decode(cookies);
    sessionId = new Cookie.fromSetCookieValue(c['s']);
    uid = new Cookie.fromSetCookieValue(c['u']);
    API.setLoginUser(c['ac'], c['sac']);
  }
}

saveLogin()async{
  Map c = {
    's':sessionId.toString(),
    'u':uid.toString(),
    'ac':API.elsAccount,
    'sac':API.elsSubAccount
  };
  await saveStrToFile(userInfoFileName, JSON.encode(c));
}

String _appDocumentsDirectory;

get appDocumentsDirectory async{
  _appDocumentsDirectory??=(await PathProvider.getApplicationDocumentsDirectory()).path;
  return _appDocumentsDirectory;
}

clearLogin()async{
  File f =new File('${await appDocumentsDirectory}/$userInfoFileName');
  if(await f.exists())f.delete();
}

saveStrToFile(String name,String data)async{
    new File('${await appDocumentsDirectory}/$name').writeAsString(data);
}

readStrFromFile(String name)async{
  File f = new File('${await appDocumentsDirectory}/$name');
  if(await f.exists()){
    return await f.readAsString();
  }
}

final HttpClient _client= new HttpClient();

clientGet(Uri uri,ContentType content) async{
  return await(
    await _client.getUrl(uri)
    ..headers.contentType = content
    ..cookies.addAll(_cookies)
  ).close();
}

clientPost(Uri uri,ContentType content,data) async{
  print('clientPost:\n$uri\n$data');
  return await(
    await _client.postUrl(uri)
    ..headers.contentType = content
    ..cookies.addAll(_cookies)
    ..write(data)
  ).close();
}

getImageFromUri(Uri uri,[bool clearCookie=true])async{
  List<int> data=[];
  if(clearCookie)sessionId=uid=null;
  var res = await clientGet(uri,ContentType.BINARY);
  if(res==null||res.cookies==null)return data;
  if(clearCookie)sessionId = res.cookies[0];
  (await res.toList()).forEach(data.addAll);
  return await decodeImageFromList(new Uint8List.fromList(data));
}

logOut(){
  clientGet(API.LOGOUT,ContentType.HTML);
  API.setLoginUser(null,null);
  clearLogin();
  uid=sessionId=null;
}

 login(Uri uri, String elsAccount,String elsSubAccount,String pwd,String identifyCode)async{
  var res = await clientPost(uri,ContentType.JSON,JSON.encode({
    'elsAccount': elsAccount,
    'elsSubAccount':elsSubAccount,
    'elsSubAccountPassword':md5.convert('$pwd'.codeUnits).toString(),
    'identifyCode':identifyCode
  }));
  if(res.cookies.length>0){
    uid=res.cookies[1];
    API.setLoginUser(elsAccount, elsSubAccount);
    saveLogin();
  }
  return JSON.decode((await res.transform(UTF8.decoder).toList()).join());
}
