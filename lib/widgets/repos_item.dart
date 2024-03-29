import 'package:flutter/material.dart';
import 'package:flutter_test_master/entity/Repository.dart';
import 'package:flutter_test_master/utils/cgq_style.dart';
import 'package:flutter_test_master/utils/navigator_utils.dart';

import 'cgq_card_item.dart';
import 'cgq_icon_text.dart';
import 'cgq_user_icon_widget.dart';

/// repos_item： 仓库Item
/// Created by Chen_Mr on 2019/6/27.

class ReposItem extends StatelessWidget {
  final ReposViewModel reposViewModel;

  final VoidCallback onPressed;

  ReposItem(this.reposViewModel, {this.onPressed}) : super();

  _getBottomItem(BuildContext context, IconData icon, String text,
      {int flex = 3}) {
    return new Expanded(
      flex: flex,
      child: new Center(
        child: new CGQIconText(
          icon,
          text,
          CGQTextsConstant.smallSubText,
          Color(CGQColorsConstant.subTextColor),
          15.0,
          padding: 5.0,
          textWidth: flex == 4
              ? (MediaQuery.of(context).size.width - 100) / 3
              : (MediaQuery.of(context).size.width - 100) / 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new CGQCardItem(
        child: new FlatButton(
            onPressed: onPressed,
            child: new Padding(
              padding: new EdgeInsets.only(
                  left: 0.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// 头像
                      new CGQUserIconWidget(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 5.0, left: 0.0),
                        width: 40.0,
                        height: 40.0,
                        image: reposViewModel.ownerPic,
                        onPressed: () {
                          NavigatorUtils.goPerson(context, reposViewModel.ownerName);
                        },
                      ),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              reposViewModel.repositoryName ?? "",
                              style: CGQTextsConstant.normalTextBold,
                            ),
                            new CGQIconText(
                              CGQIConsConstant.REPOS_ITEM_USER,
                              reposViewModel.ownerName,
                              CGQTextsConstant.smallSubLightText,
                              Color(CGQColorsConstant.subLightTextColor),
                              10.0,
                              padding: 3.0,
                            ),
                          ],
                        ),
                      ),
                      new Text(reposViewModel.repositoryType,
                          style: CGQTextsConstant.smallSubText),
                    ],
                  ),
                  new Container(
                    ///仓库描述
                    child: new Text(
                      reposViewModel.repositoryDes,
                      style: CGQTextsConstant.smallSubText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                    alignment: Alignment.topLeft,
                  ),
                  new Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _getBottomItem(context, CGQIConsConstant.REPOS_ITEM_STAR,
                          reposViewModel.repositoryStar),
                      new SizedBox(
                        width: 5,
                      ),
                      _getBottomItem(context, CGQIConsConstant.REPOS_ITEM_FORK,
                          reposViewModel.repositoryFork),
                      new SizedBox(
                        width: 5,
                      ),
                      _getBottomItem(
                        context,
                        CGQIConsConstant.REPOS_ITEM_ISSUE,
                        reposViewModel.repositoryWatch,
                        flex: 4,
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class ReposViewModel {
  String ownerName;
  String ownerPic;
  String repositoryName;
  String repositoryStar;
  String repositoryFork;
  String repositoryWatch;
  String hideWatchIcon;
  String repositoryType = "";
  String repositoryDes;

  ReposViewModel();

  ReposViewModel.fromMap(Repository data) {
    ownerName = data.owner.login;
    ownerPic = data.owner.avatar_url;
    repositoryName = data.name;
    repositoryStar = data.watchersCount.toString();
    repositoryFork = data.forksCount.toString();
    repositoryWatch = data.openIssuesCount.toString();
    repositoryType = data.language ?? '---';
    repositoryDes = data.description ?? '---';
  }

  ReposViewModel.fromTrendMap(model) {
    ownerName = model.name;
    if (model.contributors.length > 0) {
      ownerPic = model.contributors[0];
    } else {
      ownerPic = "";
    }
    repositoryName = model.reposName;
    repositoryStar = model.starCount;
    repositoryFork = model.forkCount;
    repositoryWatch = model.meta;
    repositoryType = model.language;
    repositoryDes = model.description;
  }
}
