import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class OrderListItem extends StatelessWidget{
  OrderListItem({Key key,this.data,this.onTap}):super(key:key);
  final Map data;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext content){
    String sendState='已发送';
    Color avatarColor= Colors.green[500],textColor=Colors.white;
   if(data['orderSendStatus']=='0'){
      sendState='未发送';
      avatarColor=Colors.yellow[500];
      textColor = Colors.black;
   }
    return new ListItem(
      leading: new CircleAvatar(
        child: new Text(sendState,
          style:new TextStyle(
            fontSize: 10.0,
            color: textColor
          )),
          backgroundColor:avatarColor
      ),
      title: new Text(data['purchaseOrderNumber']),
      dense:true,
      subtitle:new Text('${data["orderDate"]}\t ${data["currency"]}\t ${data["companyShortName"]}'),
      onTap: onTap
    );
  }
}
