import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'widgets/text_widgets.dart';

class LTRPreviewStyle extends StatelessWidget {
  const LTRPreviewStyle(
      {super.key,
      required this.snapshot,
      required this.linkPreviewOptions,
      this.titleFontSize,
      this.subtitleFontSize,
      this.titleColor,
      this.subtitleColor,
      this.subtitleFontWeight,
      this.titleFontWeight});

  /// [snapshot] is the data of the link you want to preview
  final ElementModel snapshot;

  /// [linkPreviewOptions] is the options you want to set for the link preview
  final NLinkPreviewOptions linkPreviewOptions;

  /// [titleFontSize] is the font size of the title of the link preview
  final double? titleFontSize;

  /// [subtitleFontSize] is the font size of the subtitle of the link preview
  final double? subtitleFontSize;

  /// [titleColor] is the color of the title of the link preview
  final Color? titleColor;

  /// [subtitleColor] is the color of the subtitle of the link preview
  final Color? subtitleColor;

  /// [titleFontWeight] is the font weight of the title of the link preview
  final FontWeight? titleFontWeight;

  /// [subtitleFontWeight] is the font weight of the subtitle of the link preview
  final FontWeight? subtitleFontWeight;
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
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
                    maxWidth: 0.3.sw(context),
                    maxHeight: 0.35.sw(context),
                    minWidth: 0.2.sw(context),
                    minHeight: 0.25.sw(context),
                  ),
                  child: Image.network(
                    snapshot.image ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
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
                          "${snapshot.title}".capitalize(),
                          fontSize: titleFontSize,
                          fontWeight: titleFontWeight,
                          textColor: titleColor,
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
                        ),
                      ),
                    ],
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
