import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class myCachedNetworkImage extends StatelessWidget{
  final int width;
  final int height;
  final String imageUrl;
  myCachedNetworkImage({this.width,this.height,this.imageUrl});
  @override
  Widget build(BuildContext context) {
    if(imageUrl.startsWith("data:image")){
      return Image.memory(
          base64.decode(imageUrl.split(',')[1]), fit: BoxFit.fill,       gaplessPlayback:true, //防止重绘
    );
    }
    else {
      return CachedNetworkImage(
        width: 100,
        height: 100,
        imageUrl: imageUrl,
        placeholder: (context, url) =>
            Center(child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      );
    }
  }
}