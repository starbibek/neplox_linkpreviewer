import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:neplox_linkpreviewer/src/link_previewer/link_preview_styles/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NonePreviewStyle extends StatelessWidget {
  const NonePreviewStyle({
    super.key,
    required this.snapshot,
    required this.linkPreviewOptions,
    this.titleColor,
    this.titleFontWeight,
    this.titleMaxLine,
    this.titleFontSize,
    this.subtitleColor,
    this.subtitleFontWeight,
    this.subtitleMaxLine,
    this.subtitleFontSize,
    this.bgColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  /// [snapshot] is the data of the link you want to preview
  final ElementModel snapshot;

  /// [linkPreviewOptions] is the options you want to set for the link preview
  final NLinkPreviewOptions linkPreviewOptions;

  /// [titleFontSize] is the font size of the title of the link preview
  final double? titleFontSize;

  /// [titleFontWeight] is the font weight property of the title of the link preview
  final double? titleFontWeight;

  /// [titleColor] is the color of the title of the link preview
  final Color? titleColor;

  ///[titleMaxLine] is the maxline of the title
  final int? titleMaxLine;

  /// [subtitleFontSize] is the font size of the subtitle of the link preview
  final double? subtitleFontSize;

  /// [subtitleFontWeight] is the font weight property of the subtitle of the link preview
  final double? subtitleFontWeight;

  /// [subtitleColor] is the color of the subtitle of the link preview
  final Color? subtitleColor;

  ///[subtitleMaxLine] is the maxline of the title
  final int? subtitleMaxLine;

  ///[bgColor] is the color of Card BarckgroundColor
  final Color? bgColor;

  ///[titleTextStyle]  it TextStyle for the title
  final TextStyle? titleTextStyle;

  ///[subtitleTextStyle] is TextStyle for subtitle or body content
  final TextStyle? subtitleTextStyle;
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: bgColor ?? Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        // if urlLaunch is enabled then only it will be clickable
        onTap: linkPreviewOptions.urlLaunch == NURLLaunch.enable
            ? () {
                launchUrlString(snapshot.link ?? "",
                    mode: linkPreviewOptions.urlLaunchIn == NURLLaunchIn.app
                        ? LaunchMode.inAppWebView
                        : LaunchMode.externalApplication);
              }
            : null,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 0.5.sw(context),
            minHeight: 0.05.sh(context),
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 0.5,
                  offset: Offset(0, 0.5),
                  spreadRadius: 0.5,
                ),
                BoxShadow(
                  color: Colors.white30,
                  blurRadius: 0.5,
                  offset: Offset(0, 0.5),
                  spreadRadius: 0.5,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bodyTextWidget(
                  context,
                  "${snapshot.description}",
                  fontSize: subtitleFontSize,
                  fontWeight: subtitleFontWeight,
                  textColor: subtitleColor,
                  maxline: subtitleMaxLine,
                  textStyle: titleTextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: bodyTextWidget(
                    context,
                    "${snapshot.description}",
                    fontSize: subtitleFontSize,
                    fontWeight: subtitleFontWeight,
                    textColor: subtitleColor,
                    maxline: subtitleMaxLine,
                    textStyle: subtitleTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
