import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test_master/common/config.dart';
import 'package:flutter_test_master/common/local/local_storage.dart';
import 'package:flutter_test_master/common/redux/cgq_state.dart';
import 'package:flutter_test_master/dao/user_dao.dart';
import 'package:flutter_test_master/utils/cgq_style.dart';
import 'package:flutter_test_master/utils/common_utils.dart';
import 'package:flutter_test_master/utils/navigator_utils.dart';
import 'package:flutter_test_master/widgets/cgq_flex_button.dart';
import 'package:flutter_test_master/widgets/cgq_input_widget.dart';

/// login_page ：登录页
/// Created by Chen_Mr on 2019/6/18.

class LoginPage extends StatefulWidget {

  static final String sName = "login";

  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>{

  var _userName = "";

  var _password = "";

  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();

  _LoginPageState() : super();

  initParams() async {
    /// 获取已经登录的用户名和密码
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);

    /// 通过输入控制器 填入输入框
    userController.value = new TextEditingValue(text: _userName ?? "");
    pwController.value = new TextEditingValue(text: _password ?? "");
  }

  @override
  Widget build(BuildContext context) {
    ///共享 store
    return new StoreBuilder<CGQState>(builder: (context, store) {
      /// 触摸收起键盘
      return new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: new Container(
            color: Theme.of(context).primaryColor,
            child: new Center(
              ///防止overFlow的现象
              child: SafeArea(
                ///同时弹出键盘不遮挡
                child: SingleChildScrollView(
                  child: new Card(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    color: Color(CGQColorsConstant.cardWhite),
                    margin: const EdgeInsets.only(left:30.0, right: 30.0),
                    child: new Padding(
                      padding: new EdgeInsets.only(left: 30.0, top: 40.0, right: 30.0, bottom: 0.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Image(image: new AssetImage(CGQIConsConstant.DEFAULT_USER_ICON), width: 90.0, height: 90.0),
                          new Padding(padding: new EdgeInsets.all(10.0)),
                          new CGQInputWidget(
                            hintText: CommonUtils.getLocale(context).login_username_hint_text,
                            iconData: CGQIConsConstant.LOGIN_USER,
                            onChanged: (String value) {
                              _userName = value;
                            },
                            controller: userController,
                          ),
                          new Padding(padding: new EdgeInsets.all(10.0)),
                          new CGQInputWidget(
                            hintText: CommonUtils.getLocale(context).login_password_hint_text,
                            iconData: CGQIConsConstant.LOGIN_PW,
                            obscureText: true,
                            onChanged: (String value) {
                              _password = value;
                            },
                            controller: pwController,
                          ),
                          new Padding(padding: new EdgeInsets.all(30.0)),
                          new CGQFlexButton(
                            text: CommonUtils.getLocale(context).login_text,
                            color: Theme.of(context).primaryColor,
                            textColor: Color(CGQColorsConstant.textWhite),
                            onPress: () {
                              if (_userName == null || _userName.length == 0) {
                                return;
                              }
                              if (_password == null || _password.length == 0) {
                                return;
                              }
                              CommonUtils.showLoadingDialog(context);
                              UserDao.login(_userName.trim(), _password.trim(), store).then((res) {
                                Navigator.pop(context);
                                if (res != null && res.result) {
                                  new Future.delayed(const Duration(seconds: 1), () {
                                    NavigatorUtils.goHome(context);
                                    return true;
                                  });
                                }
                              });
                            },
                          ),
                          new Padding(padding: new EdgeInsets.all(30.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

}