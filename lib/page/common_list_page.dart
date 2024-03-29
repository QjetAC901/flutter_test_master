import 'package:flutter/material.dart';
import 'package:flutter_test_master/dao/ReposDao.dart';
import 'package:flutter_test_master/dao/user_dao.dart';
import 'package:flutter_test_master/utils/navigator_utils.dart';
import 'package:flutter_test_master/widgets/pull/cgq_pull_load_widget.dart';
import 'package:flutter_test_master/widgets/repos_item.dart';
import 'package:flutter_test_master/widgets/state/cgq_list_state.dart';
import 'package:flutter_test_master/widgets/user_item.dart';

/// 通用list

class CommonListPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String showType;

  final String dataType;

  final String title;

  CommonListPage(this.title, this.showType, this.dataType,
      {this.userName, this.reposName});

  @override
  _CommonListPageState createState() => _CommonListPageState();
}

class _CommonListPageState extends State<CommonListPage>
    with
        AutomaticKeepAliveClientMixin<CommonListPage>,
        CGQListState<CommonListPage> {
  _CommonListPageState();

  _renderItem(index) {
    if (pullLoadWidgetControl.dataList.length == 0) {
      return null;
    }
    var data = pullLoadWidgetControl.dataList[index];
    switch (widget.showType) {
      case 'repository':
        ReposViewModel reposViewModel = ReposViewModel.fromMap(data);
        return new ReposItem(reposViewModel, onPressed: () {
          NavigatorUtils.goReposDetail(
              context, reposViewModel.ownerName, reposViewModel.repositoryName);
        });
      case 'user':
        return new UserItem(UserItemViewModel.fromMap(data), onPressed: () {
          NavigatorUtils.goPerson(context, data.login);
        });
      case 'org':
        return new UserItem(UserItemViewModel.fromOrgMap(data), onPressed: () {
          NavigatorUtils.goPerson(context, data.login);
        });
      case 'issue':
        return null;
      case 'release':
        return null;
      case 'notify':
        return null;
    }
  }

  _getDataLogic() async {
    switch (widget.dataType) {
      case 'follower':
        return await UserDao.getFollowerListDao(widget.userName, page,
            needDb: page <= 1);
      case 'followed':
        return await UserDao.getFollowedListDao(widget.userName, page,
            needDb: page <= 1);
      case 'user_repos':
        return await ReposDao.getUserRepositoryDao(widget.userName, page, null,
            needDb: page <= 1);
      case 'user_star':
        return await ReposDao.getStarRepositoryDao(widget.userName, page, null,
            needDb: page <= 1);
      case 'repo_star':
        return await ReposDao.getRepositoryStarDao(
            widget.userName, widget.reposName, page,
            needDb: page <= 1);
      case 'repo_watcher':
        return await ReposDao.getRepositoryWatcherDao(
            widget.userName, widget.reposName, page,
            needDb: page <= 1);
      case 'repo_fork':
        return await ReposDao.getRepositoryForksDao(
            widget.userName, widget.reposName, page,
            needDb: page <= 1);
      case 'repo_release':
        return null;
      case 'repo_tag':
        return null;
      case 'notify':
        return null;
      case 'history':
        return await ReposDao.getHistoryDao(page);
      case 'topics':
        return await ReposDao.searchTopicRepositoryDao(widget.userName,
            page: page);
      case 'user_be_stared':
        return null;
      case 'user_orgs':
        return await UserDao.getUserOrgsDao(widget.userName, page,
            needDb: page <= 1);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(
        widget.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )),
      body: CGQPullLoadWidget(
        (BuildContext context, int index) => _renderItem(index),
        handleRefresh,
        pullLoadWidgetControl,
        onLoadMore,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
