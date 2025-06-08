import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AImage extends StatelessWidget {
  const AImage(
    this.name, {
    super.key,
    this.height,
    this.width,
    this.fit,
    this.color,
    this.alignment,
    this.placeholder,
    this.builder,
  });

  final String name;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final Alignment? alignment;
  final Widget? placeholder;
  final ImageFrameBuilder? builder;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/$name.png",
      key: key,
      fit: fit,
      color: color,
      alignment: alignment ?? Alignment.center,
      frameBuilder: builder,
      height: height,
      width: width,
      errorBuilder: (context, error, stackTrace) {
        return placeholder ?? SizedBox(height: height, width: width);
      },
    );
  }
}

Widget loadImage(
  String name, {
  double? height,
  double? width,
  BoxFit? fit,
  bool isCircle = false,
  Widget? placeholder,
  Color? color,
}) {
  color ??= const Color.fromARGB(33, 201, 201, 201);
  late final child =
      placeholder ??
      Container(
        height: height,
        width: width,
        decoration:
            isCircle
                ? ShapeDecoration(shape: const StadiumBorder(), color: color)
                : null,
        color: isCircle ? null : color,
      );

  if (name.isEmpty) return child;

  final image = CachedNetworkImage(
    imageUrl: name,
    height: height,
    width: width,
    fit: fit,
    fadeInDuration: const Duration(milliseconds: 300),
    fadeOutDuration: const Duration(milliseconds: 500),
    errorWidget: (context, url, error) {
      return child;
    },
    placeholder: (context, url) {
      return child;
    },
  );

  return image;
}

/// 获取图片宽高，加载错误情况返回 Rect.zero.（单位 px）
Future<Rect> getImageWH({
  Image? image,
  String? url,
  String? localUrl,
  String? package,
}) {
  if (image == null &&
      url?.isNotEmpty != true &&
      localUrl?.isNotEmpty != true) {
    return Future.value(Rect.zero);
  }
  Completer<Rect> completer = Completer<Rect>.sync();
  // Image img = image ??
  //     ((url != null && url.isNotEmpty)
  //         ? Image.network(url)
  //         : Image.asset(localUrl!, package: package));
  ImageProvider img;
  if (url != null) {
    img = CachedNetworkImageProvider(url);
  } else if (image != null) {
    img = image.image;
  } else {
    img = AssetImage(localUrl!, package: package);
  }
  late ImageStreamListener listener;

  Rect? rect;
  final stream = img.resolve(const ImageConfiguration());
  stream.addListener(
    listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(
          rect = Rect.fromLTWH(
            0,
            0,
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ),
        );
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          stream.removeListener(listener);
          info.dispose();
        });
      },
      onError: (Object exception, StackTrace? stackTrace) {
        completer.completeError(exception, stackTrace);
        stream.removeListener(listener);
      },
    ),
  );

  // 同步
  if (rect != null) {
    return SynchronousFuture(rect!);
  }
  return completer.future;
}
