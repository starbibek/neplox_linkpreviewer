import 'package:flutter/cupertino.dart';

import '../../../index.dart';

headerTextWidget(BuildContext context, String text,
    {fontSize, textColor, fontWeight, maxline}) {
  return Text(
    text,
    maxLines: maxline ?? 2,
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
    maxLines: maxline ?? 5,
    style: TextStyle(
      fontSize: fontSize ?? 0.010.sres(context),
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}
