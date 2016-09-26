import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';

final Map<String,WidgetBuilder> APP_ROUTER = <String,WidgetBuilder>{
  Home.routeName:(BuildContext context)=> new Home(),
  LoginPage.routeName:(BuildContext context)=>new LoginPage()
};


class API{
  static final String stroagePath = 'opt/nfsshare';
  static final String _imagePath = 'ELSServer/image/identifyingCode.img';
  static final String _loginPath = 'ELSServer/rest/AccountService/login';
  static final String _logoutPath ='ELSServer/login/logout.jsp';
  static final String _findPurchaseOrderByCondtion = 'ELSServer/rest/PurchaseOrderService/order/findPurchaseOrderByCondtion';
  static final String _loginHost = 'cs.51qqt.com';
  static final String sysHost  = 'cs.51qqt.com';
  static String _elsAccount,_elsSubAccount;

  static void setLoginUser(String elsAccount,String elsSubAccount){
    _elsAccount=elsAccount;
    _elsSubAccount=elsSubAccount;
  }

  static get elsAccount {
    return _elsAccount;
  }

  static get elsSubAccount {
    return _elsSubAccount;
  }

  static final Uri LOGIN = new Uri.http(_loginHost, _loginPath);
  static final Uri LOGOUT = new Uri.http(_loginHost, _logoutPath);
  static final Uri GET_PURCHASE_ORDER = new Uri.http(sysHost, _findPurchaseOrderByCondtion);
  static final Uri IDENTIFY_CODE_IMAGE = new Uri.http(_loginHost, _imagePath);
  static get   LOGIN_USER_INFO => new Uri.http(sysHost,
    '/ELSServer/rest/AccountService/findSubaccount/$elsAccount/$elsSubAccount'
  );
}
