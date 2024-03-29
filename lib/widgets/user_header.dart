import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test_master/common/localization/default_localizations.dart';
import 'package:flutter_test_master/entity/User.dart';
import 'package:flutter_test_master/entity/UserOrg.dart';
import 'package:flutter_test_master/utils/cgq_style.dart';
import 'package:flutter_test_master/utils/common_utils.dart';
import 'package:flutter_test_master/utils/navigator_utils.dart';

import 'cgq_card_item.dart';
import 'cgq_icon_text.dart';
import 'cgq_user_icon_widget.dart';

/// 用户详情头部

class UserHeaderItem extends StatelessWidget {
  final User userInfo;

  final String beStaredCount;

  final Color notifyColor;

  final Color themeColor;

  final VoidCallback refreshCallBack;

  final List<UserOrg> orgList;

  UserHeaderItem(this.userInfo, this.beStaredCount, this.themeColor,
      {this.notifyColor, this.refreshCallBack, this.orgList});

  ///通知ICon
  _getNotifyIcon(BuildContext context, Color color) {
    if (notifyColor == null) {
      return Container();
    }
    return new RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.only(top: 0.0, right: 5.0, left: 5.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new ClipOval(
          child: new Icon(
            CGQIConsConstant.USER_NOTIFY,
            color: color,
            size: 18.0,
          ),
        ),
        onPressed: () {
          NavigatorUtils.goNotifyPage(context).then((res) {
            refreshCallBack?.call();
          });
        });
  }

  ///用户组织
  _renderOrgs(BuildContext context, List<UserOrg> orgList) {
    if (orgList == null || orgList.length == 0) {
      return new Container();
    }
    List<Widget> list = new List();

    renderOrgsItem(UserOrg orgs) {
      return CGQUserIconWidget(
          padding: const EdgeInsets.only(right: 5.0, left: 5.0),
          width: 30.0,
          height: 30.0,
          image: orgs.avatarUrl ?? CGQIConsConstant.DEFAULT_REMOTE_PIC,
          onPressed: () {
            NavigatorUtils.goPerson(context, orgs.login);
          });
    }

    int length = orgList.length > 3 ? 3 : orgList.length;

    list.add(new Text(CommonUtils.getLocale(context).user_orgs_title + ":",
        style: CGQTextsConstant.smallSubLightText));

    for (int i = 0; i < length; i++) {
      list.add(renderOrgsItem(orgList[i]));
    }
    if (orgList.length > 3) {
      list.add(new RawMaterialButton(
          onPressed: () {
            NavigatorUtils.gotoCommonList(
                context,
                userInfo.login +
                    " " +
                    CommonUtils.getLocale(context).user_orgs_title,
                "org",
                "user_orgs",
                userName: userInfo.login);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.only(right: 5.0, left: 5.0),
          constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          child: Icon(
            Icons.more_horiz,
            color: Color(CGQColorsConstant.white),
            size: 18.0,
          )));
    }
    return Row(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return new CGQCardItem(
        color: themeColor,
        elevation: 0,
        margin: EdgeInsets.all(0.0),
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0))),
        child: new Padding(
          padding: new EdgeInsets.only(
              left: 10.0, top: 10.0, right: 10.0, bottom: 0.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ///用户头像
                  new RawMaterialButton(
                      onPressed: () {
                        if (userInfo.avatar_url != null) {
                          NavigatorUtils.gotoPhotoViewPage(
                              context, userInfo.avatar_url);
                        }
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(0.0),
                      constraints:
                          const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
                      child: new ClipOval(
                        child: new FadeInImage.assetNetwork(
                          placeholder: CGQIConsConstant.DEFAULT_USER_ICON,
                          //预览图
                          fit: BoxFit.fitWidth,
                          image: userInfo.avatar_url ??
                              CGQIConsConstant.DEFAULT_REMOTE_PIC,
                          width: 80.0,
                          height: 80.0,
                        ),
                      )),
                  new Padding(padding: EdgeInsets.all(10.0)),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            ///用户名
                            new Text(userInfo.login ?? "",
                                style: CGQTextsConstant.largeTextWhiteBold),
                            _getNotifyIcon(context, notifyColor),
                          ],
                        ),
                        new Text(userInfo.name == null ? "" : userInfo.name,
                            style: CGQTextsConstant.smallSubLightText),

                        ///用户组织
                        new CGQIconText(
                          CGQIConsConstant.USER_ITEM_COMPANY,
                          userInfo.company ??
                              CommonUtils.getLocale(context).nothing_now,
                          CGQTextsConstant.smallSubLightText,
                          Color(CGQColorsConstant.subLightTextColor),
                          10.0,
                          padding: 3.0,
                        ),

                        ///用户位置
                        new CGQIconText(
                          CGQIConsConstant.USER_ITEM_LOCATION,
                          userInfo.location ??
                              CommonUtils.getLocale(context).nothing_now,
                          CGQTextsConstant.smallSubLightText,
                          Color(CGQColorsConstant.subLightTextColor),
                          10.0,
                          padding: 3.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              new Container(

                  ///用户博客
                  child: new RawMaterialButton(
                    onPressed: () {
                      if (userInfo.blog != null) {
                        CommonUtils.launchOutURL(userInfo.blog, context);
                      }
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0.0),
                    constraints:
                        const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
                    child: new CGQIconText(
                      CGQIConsConstant.USER_ITEM_LINK,
                      userInfo.blog ??
                          CommonUtils.getLocale(context).nothing_now,
                      (userInfo.blog == null)
                          ? CGQTextsConstant.smallSubLightText
                          : CGQTextsConstant.smallActionLightText,
                      Color(CGQColorsConstant.subLightTextColor),
                      10.0,
                      padding: 3.0,
                      textWidth: MediaQuery.of(context).size.width - 50,
                    ),
                  ),
                  margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                  alignment: Alignment.topLeft),

              ///组织
              _renderOrgs(context, orgList),

              ///用户描述
              new Container(
                  child: new Text(
                    userInfo.bio == null
                        ? CommonUtils.getLocale(context).user_create_at +
                            CommonUtils.getDateStr(userInfo.created_at)
                        : userInfo.bio +
                            "\n" +
                            CommonUtils.getLocale(context).user_create_at +
                            CommonUtils.getDateStr(userInfo.created_at),
                    style: CGQTextsConstant.smallSubLightText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                  alignment: Alignment.topLeft),
              new Padding(padding: EdgeInsets.only(bottom: 5.0)),
              /*new Divider(
                color: Color(GSYColors.subLightTextColor),
              ),*/
            ],
          ),
        ));
  }
}

class UserHeaderBottom extends StatelessWidget {
  final User userInfo;
  final String beStaredCount;
  final Radius radius;

  UserHeaderBottom(this.userInfo, this.beStaredCount, this.radius);

  ///底部状态栏
  _getBottomItem(String title, var value, onPressed) {
    String data = value == null ? "" : value.toString();
    TextStyle valueStyle = (value != null && value.toString().length > 6)
        ? CGQTextsConstant.minText
        : CGQTextsConstant.smallSubLightText;
    TextStyle titleStyle = (title != null && title.toString().length > 6)
        ? CGQTextsConstant.minText
        : CGQTextsConstant.smallSubLightText;
    return new Expanded(
      child: new Center(
          child: new RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.only(top: 5.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: title, style: titleStyle),
                    TextSpan(text: "\n", style: valueStyle),
                    TextSpan(text: data, style: valueStyle)
                  ],
                ),
              ),
              onPressed: onPressed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///用户底部状态
    return new CGQCardItem(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.all(0.0),
      shape: new RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(bottomLeft: radius, bottomRight: radius)),
      child: Container(
        alignment: Alignment.center,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _getBottomItem(
              CGQLocalizations.of(context).currentLocalized.user_tab_repos,
              userInfo.public_repos,
              () {
                NavigatorUtils.gotoCommonList(
                    context, userInfo.login, "repository", "user_repos",
                    userName: userInfo.login);
              },
            ),
            new Container(
                width: 0.3,
                height: 40.0,
                alignment: Alignment.center,
                color: Color(CGQColorsConstant.subLightTextColor)),
            _getBottomItem(
              CommonUtils.getLocale(context).user_tab_fans,
              userInfo.followers,
              () {
                NavigatorUtils.gotoCommonList(
                    context, userInfo.login, "user", "follower",
                    userName: userInfo.login);
              },
            ),
            new Container(
                width: 0.3,
                height: 40.0,
                alignment: Alignment.center,
                color: Color(CGQColorsConstant.subLightTextColor)),
            _getBottomItem(
              CommonUtils.getLocale(context).user_tab_focus,
              userInfo.following,
              () {
                NavigatorUtils.gotoCommonList(
                    context, userInfo.login, "user", "followed",
                    userName: userInfo.login);
              },
            ),
            new Container(
                width: 0.3,
                height: 40.0,
                alignment: Alignment.center,
                color: Color(CGQColorsConstant.subLightTextColor)),
            _getBottomItem(
              CommonUtils.getLocale(context).user_tab_star,
              userInfo.starred,
              () {
                NavigatorUtils.gotoCommonList(
                    context, userInfo.login, "repository", "user_star",
                    userName: userInfo.login);
              },
            ),
            new Container(
                width: 0.3,
                height: 40.0,
                alignment: Alignment.center,
                color: Color(CGQColorsConstant.subLightTextColor)),
            _getBottomItem(
              CommonUtils.getLocale(context).user_tab_honor,
              beStaredCount,
              () {},
            ),
          ],
        ),
      ),
    );
  }
}

class UserHeaderChart extends StatelessWidget {
  final User userInfo;

  UserHeaderChart(this.userInfo);

  _renderChart(context) {
    double height = 140.0;
    double width = 3 * MediaQuery.of(context).size.width / 2;
    if (userInfo.login != null && userInfo.type == "Organization") {
      return new Container();
    }
    return (userInfo.login != null)
        ? new Card(
            margin:
                EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0, bottom: 0.0),
            color: Color(CGQColorsConstant.white),
            child: new SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: new Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                width: width,
                height: height,

                ///svg chart
                child: new SvgPicture.network(
                  CommonUtils.getUserChartAddress(userInfo.login),
                  width: width,
                  height: height - 10,
                  allowDrawingOutsideViewBox: true,
                  placeholderBuilder: (BuildContext context) => new Container(
                        height: height,
                        width: width,
                        child: Center(
                          child: SpinKitRipple(
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                ),
              ),
            ),
          )
        : new Container(
            height: height,
            child: Center(
              child: SpinKitRipple(color: Theme.of(context).primaryColor),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          new Container(
              child: new Text(
                (userInfo.type == "Organization")
                    ? CommonUtils.getLocale(context).user_dynamic_group
                    : CommonUtils.getLocale(context).user_dynamic_title,
                style: CGQTextsConstant.normalTextBold,
                overflow: TextOverflow.ellipsis,
              ),
              margin: new EdgeInsets.only(top: 15.0, bottom: 15.0, left: 12.0),
              alignment: Alignment.topLeft),
          _renderChart(context),
        ],
      ),
    );
  }
}
