import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:neplox_linkpreviewer/src/link_previewer/link_preview_styles/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RTLPreviewStyle extends StatelessWidget {
  const RTLPreviewStyle({
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
      color: bgColor ?? Theme.of(context).cardColor,
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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0.5.sw(context),
            minHeight: 0.05.sh(context),
          ),
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 0.6.sw(context),
                    minWidth: 0.3.sw(context),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(0.004.sres(context)),
                        child: headerTextWidget(
                          context,
                          "${snapshot.title}",
                          fontSize: titleFontSize,
                          fontWeight: titleFontWeight,
                          textColor: titleColor,
                          maxline: titleMaxLine,
                          textStyle: titleTextStyle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0.004.sres(context)),
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 0.3.sw(context),
                    maxHeight: 0.35.sw(context),
                    minWidth: 0.2.sw(context),
                    minHeight: 0.28.sw(context),
                  ),
                  child: Image.network(
                    snapshot.image ?? "",
                    fit: BoxFit.cover,
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
