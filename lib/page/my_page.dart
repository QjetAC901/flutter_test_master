import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test_master/common/redux/user_redux.dart';
import 'package:flutter_test_master/dao/ReposDao.dart';
import 'package:flutter_test_master/dao/event_dao.dart';
import 'package:flutter_test_master/dao/user_dao.dart';
import 'package:flutter_test_master/widgets/pull/nested/cgq_nested_pull_load_widget.dart';
import 'package:flutter_test_master/widgets/state/base_person_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_test_master/common/redux/cgq_state.dart';
import 'package:flutter_test_master/utils/cgq_style.dart';

/// my_page:主页我的Tab页面
/// Created by Chen_Mr on 2019/6/27.

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }
}

class _MyPageState extends BasePersonState<MyPage> {
  String beStaredCount = '---';

  Color notifyColor = const Color(CGQColorsConstant.subTextColor);

  Store<CGQState> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of(context);
  }

  ///从全局状态中获取我的用户名
  _getUserName() {
    if (_getStore()?.state?.userInfo == null) {
      return null;
    }
    return _getStore()?.state?.userInfo?.login;
  }

  ///从全局状态中获取我的用户类型
  getUserType() {
    if (_getStore()?.state?.userInfo == null) {
      return null;
    }
    return _getStore()?.state?.userInfo?.type;
  }

  ///更新通知图标颜色
  _refreshNotify() {
    UserDao.getNotifyDao(false, false, 0).then((res) {
      Color newColor;
      if (res != null && res.result && res.data.length > 0) {
        newColor = Color(CGQColorsConstant.actionBlue);
      } else {
        newColor = Color(CGQColorsConstant.subLightTextColor);
      }
      if (isShow) {
        setState(() {
          notifyColor = newColor;
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pullLoadWidgetControl.needHeader = true;
    super.initState();
  }

  _getDataLogic() async {
    if (_getUserName() == null) {
      return [];
    }
    if (getUserType() == "Organization") {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    return await EventDao.getEventDao(_getUserName(),
        page: page, needDb: page <= 1);
  }

  @override
  requestRefresh() async {
    if (_getUserName() != null) {
      ///通过 redux 提交更新用户数据行为
      ///触发网络请求更新
      _getStore().dispatch(FetchUserAction());

      ///获取用户组织信息
      getUserOrg(_getUserName());

      ///获取用户仓库前100个star统计数据
      ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
        if (res != null && res.result) {
          if (isShow) {
            setState(() {
              beStaredCount = res.data.toString();
            });
          }
        }
      });
      _refreshNotify();
    }
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => false;

  @override
  bool get needHeader => false;

  @override
  void didChangeDependencies() {
    if (pullLoadWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new StoreBuilder<CGQState>(
      builder: (context, store) {
        return CGQNestedPullLoadWidget(
          pullLoadWidgetControl,
          (BuildContext context, int index) => renderItem(
              index, store.state.userInfo, beStaredCount, notifyColor, () {
            _refreshNotify();
          }, orgList),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshKey,
          headerSliverBuilder: (context, _) {
            return sliverBuilder(
                context, _, store.state.userInfo, notifyColor, beStaredCount,
                () {
              _refreshNotify();
            });
          },
        );
      },
    );
  }
}
