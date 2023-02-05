import 'package:flutter/cupertino.dart';

import '../../../index.dart';

headerTextWidget(BuildContext context, String text,
    {fontSize, textColor, fontWeight, maxline}) {
  return Text(
    text,
    maxLines: maxline ?? 2,
    softWrap: true,
    textScaleFactor: ((fontSize ?? 14)) / (((fontSize ?? 14)) + (maxline ?? 2)),
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: fontSize ?? 0.014.sres(context),
      fontWeight: fontWeight ?? FontWeight.bold,
    ),
  );
}

bodyTextWidget(BuildContext context, String text,
    {fontSize, textColor, fontWeight, maxline}) {
  return Text(
    text,
    maxLines: maxline ?? 4,
    softWrap: true,
    textScaleFactor: ((fontSize ?? 12)) / (((fontSize ?? 12)) + (maxline ?? 4)),
    style: TextStyle(
      fontSize: fontSize ?? 0.012.sres(context),
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}
