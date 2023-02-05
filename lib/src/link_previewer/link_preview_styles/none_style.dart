import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:neplox_linkpreviewer/src/link_previewer/link_preview_styles/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NonePreviewStyle extends StatelessWidget {
  const NonePreviewStyle(
      {super.key,
      required this.snapshot,
      required this.linkPreviewOptions,
      this.titleFontSize,
      this.subtitleFontSize,
      this.titleColor,
      this.subtitleColor});

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
                headerTextWidget(context, "${snapshot.title}"),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: bodyTextWidget(context, "${snapshot.description}"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
