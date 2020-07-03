import 'dart:async';
import 'helps/helps.dart';
import 'package:flutter/material.dart';

class c_Banner extends StatefulWidget {
  final List<String> _images;
  final double height;
  final ValueChanged<int> onTap;
  final Curve curve;

  c_Banner(
    this._images, {
    this.height = 250,
    this.onTap,
    this.curve = Curves.linear,
  }) : assert(_images != null);

  @override
  _c_BannerState createState() => _c_BannerState(height:height);
}

class _c_BannerState extends State<c_Banner> {
  PageController _pageController;
  int _curIndex;
  final double height;
  //Timer _timer;
  _c_BannerState({this.height});
  @override
  void initState() {
    super.initState();
    _curIndex = widget._images.length * 5;
    _pageController = PageController(initialPage: _curIndex);
    //_initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: height,
          color: Colors.white,
          child:
      Column(
        //alignment: Alignment.bottomCenter,
        children: <Widget>[
          Flexible(child: _buildPageView()),
          _buildIndicator()
        ]));
  }

  //小圓點指示器
  Widget _buildIndicator() {
    var length = widget._images.length;
    return Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        height: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget._images.map((s) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: ClipOval(
                child: Container(
                  width: 8,
                  height: 8,
                  color: s == widget._images[_curIndex % length]
                      ? ButtonColorNormal
                      : ButtonColor_UNSelect,
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildPageView() {
    var length = widget._images.length;
    return Container(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _curIndex = index;
            if (index == 0) {
              _curIndex = length;
              _changePage();
            }
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onPanDown: (details) {
              //_cancelTimer();
            },
            onTap: () {
              /*Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('当前 page 为 ${index % length}'),
                  duration: Duration(milliseconds: 500),
                ),
              );*/
            },
            child: Image.network(widget._images[index % length],
                fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  /// 点击到图片的时候取消定时任务
  ///
  /*_cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      _initTimer();
    }
  }

  /// 初始化定时任务
  _initTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 3), (t) {
        _curIndex++;
        _pageController.animateToPage(
          _curIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      });
    }
  }*/

  /// 切换页面，并刷新小圆点
  _changePage() {
    Timer(Duration(milliseconds: 350), () {
      _pageController.jumpToPage(_curIndex);
    });
  }
}
