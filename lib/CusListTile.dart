import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'banner.dart';
import 'helps/helps.dart';

class CusListTile extends StatelessWidget {
  const CusListTile({
    this.thumbnail,
    this.title,
    this.subtitle,
    this.onTap,
    this.cIcon
  });

  final Widget thumbnail;
  final Widget title;
  final Widget subtitle;
  final onTap;
  final Widget cIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(padding: EdgeInsets.all(8), child: thumbnail),
              ),
              Expanded(
                flex: 3,
                child: _VideoDescription(
                  title: title,
                  subtitle: subtitle,
                ),
              ),
              cIcon??const Icon(
                Icons.more_vert,
                size: 16.0,
              ),
            ],
          ),
        ));
  }
}
class _VideoDescription extends StatelessWidget {
  const _VideoDescription({
    Key key,
    this.title,
    this.subtitle,
    this.viewCount,
  }) : super(key: key);

  final Widget title;
  final Widget subtitle;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 16.0, 20.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title,
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          subtitle,
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
        ],
      ),
    );
  }
}
class CusListTile_ImageFirst extends StatelessWidget {
  const CusListTile_ImageFirst({
    this.title,
    this.thumbnail,
    this.onTap,
  });

  final List<String> thumbnail;
  final Widget title;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: title,
              ),
              Icon(Icons.keyboard_arrow_right,
                  color: ButtonColorSubmit, size: 30.0),
            ]),
            Container(
              child: Flexible(
                child:Padding(child: c_Banner(thumbnail) ,padding: EdgeInsets.fromLTRB(16, 8, 16, 8),),
              ),
              height: 180,
            )
          ],
        ));

    /*Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    title,
                    c_Banner(thumbnail),
                  ],
                ),
                const Icon(
                  Icons.more_vert,
                  size: 16.0,
                )
              ],
            )));*/
  }
}
