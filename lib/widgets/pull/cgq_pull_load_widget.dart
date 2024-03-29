import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'package:flutter_test_master/utils/cgq_style.dart';

/// CGQPullLoadWidget:通用上拉加载下拉刷新Widget
/// Created by Chen_Mr on 2019/6/13.

class CGQPullLoadWidget extends StatefulWidget {
  /// item 渲染
  final IndexedWidgetBuilder itemBuilder;

  /// 加载更多回调
  final RefreshCallback onLoadMore;

  /// 控制器，比如数据和一些配置
  final CGQPullLoadWidgetControl control;

  final Key refreshKey;

  /// 下拉刷新回调
  final RefreshCallback onRefresh;

  CGQPullLoadWidget(
      this.itemBuilder, this.onLoadMore, this.control, this.onRefresh,
      {this.refreshKey});

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

class _CGQPullLoadWidgetState extends State<CGQPullLoadWidget> {
  final IndexedWidgetBuilder itemBuilder;

  final RefreshCallback onLoadMore;

  final RefreshCallback onRefresh;

  final Key refreshKey;

  CGQPullLoadWidgetControl control;

  _CGQPullLoadWidgetState(this.itemBuilder, this.onLoadMore, this.onRefresh,
      this.control, this.refreshKey);

  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    this.control.needLoadMore?.addListener(() {
      /// 延迟两秒等待确认
      Future.delayed(Duration(seconds: 2), () {
        _scrollController.notifyListeners();
      });
    });

    /// 增加滑动监听
    _scrollController
      ..addListener(() {
        /// 判断当前滑动位置是不是到达底部  触发加载更多
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (control.needLoadMore.value) {
            this.onLoadMore?.call();
          }
        }
      });
    super.initState();
  }

  /// 根据配置状态返回实际列表数量
  /// 实际上这里可以根据你的需要做更多的处理
  /// 比如多个头部，是否需要空页面，是否需要显示加载更多
  _getListCount() {
    if (control.needHeader) {
      /// 如果需要头部，用Item 0 的Widget 作为ListView的头部
      /// 列表数量大于0时，因为头部和底部加载更多选项，需要对列表数据总数+2
      return (control.dataList.length > 0)
          ? control.dataList.length + 2
          : control.dataList.length + 1;
    } else {
      /// 如果不需要头部，在没有数据时，固定返回数量1 用于空页面呈现
      if (control.dataList.length == 0) {
        return 1;
      }

      /// 如果有数据，因为不加载更多选项，需要对列表数据总数+1
      return (control.dataList.length > 0)
          ? control.dataList.length + 1
          : control.dataList.length;
    }
  }

  /// 根据配置状态返回实际列表渲染Item
  _getItem(int index) {
    if (!control.needHeader &&
        index == control.dataList.length &&
        control.dataList.length != 0) {
      /// 如果不需要头部，并且数据不为0，当index等于数据长度时，渲染加载更多Item
      /// （因为index是从0开始）
      return _buildProgressIndicator();
    } else if (control.needHeader &&
        index == _getListCount() - 1 &&
        control.dataList.length != 0) {
      /// 如果需要头部，并且数据不为0，当index等于实际渲长度 -1 时，绚烂加载更多Item
      /// （因为index是从1开始）
      return _buildProgressIndicator();
    } else if (!control.needHeader && control.dataList.length == 0) {
      /// 如果不需要头部，并且数据为0，渲染空页面
      return _buildEmpty();
    } else {
      /// 回调外部正常渲染Item，如果这里有需要，可以直接返回相对位置的Index
      return itemBuilder(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(

        /// GlobalKey,用户外部获取RefreshIndicator的State，做显示刷新
        key: refreshKey,
        child: new ListView.builder(
          /// 保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题
          physics: const AlwaysScrollableScrollPhysics(),

          /// 根据状态返回子控件
          itemBuilder: (context, index) {
            return _getItem(index);
          },

          /// 根据状态返回数量
          itemCount: _getListCount(),

          /// 滑动监听
          controller: _scrollController,
        ),

        /// 下拉刷新触发，返回的是一个Future
        onRefresh: onRefresh);
  }

  /// 空页面
  Widget _buildEmpty() {
    return new Container(
      height: MediaQuery.of(context).size.height - 100,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: new Image(
              image: new AssetImage(CGQIConsConstant.DEFAULT_IMAGE),
              width: 70.0,
              height: 70.0,
            ),
          ),
          Container(
            child: Text("没有找到数据！", style: CGQTextsConstant.normalText),
          )
        ],
      ),
    );
  }

  /// 上拉加载更多
  Widget _buildProgressIndicator() {
    /// 是否需要显示上拉加载更多的loading
    Widget bottomWidget = (control.needLoadMore.value)
        ? new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SpinKitRotatingCircle(color: Theme.of(context).primaryColor),
              new Container(width: 5.0),
              new Text(
                "正在加载更多",
                style: TextStyle(
                    color: Color(0xFF121917),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          )

        /// 不需要加载
        : new Container();
    return new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Center(
          child: bottomWidget,
        ));
  }
}

class CGQPullLoadWidgetControl {
  ///数据，对齐增减，不能替换
  List dataList = new List();

  ///是否需要加载更多
  ValueNotifier<bool> needLoadMore = new ValueNotifier(false);

  ///是否需要头部
  bool needHeader = false;
}
