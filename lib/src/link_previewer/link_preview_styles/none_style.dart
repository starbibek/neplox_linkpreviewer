import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:neplox_linkpreviewer/src/link_previewer/link_preview_styles/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'style/styles.dart';

class NonePreviewStyle extends StatelessWidget {
  const NonePreviewStyle({
    super.key,
    required this.snapshot,
    required this.linkPreviewOptions,
    required this.nTypographyStyle,
    required this.nCardStyle,
  });

  final ElementModel snapshot;
  final NLinkPreviewOptions linkPreviewOptions;
  final NTypographyStyle nTypographyStyle;
  final NCardStyle nCardStyle;
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: nCardStyle.bgColor,
      shadowColor: nCardStyle.shadowColor,
      elevation: nCardStyle.elevation,
      borderRadius: nCardStyle.borderRadius,
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
                    fontSize: nTypographyStyle.bodyFontSize,
                        fontWeight: nTypographyStyle.bodyFontWeight,
                        textColor: nTypographyStyle.bodyColor,
                        maxline: nTypographyStyle.bodyMaxLine,
                        textStyle: nTypographyStyle.bodyTextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: bodyTextWidget(
                    context,
                    "${snapshot.description}",
                    fontSize: nTypographyStyle.titleFontSize,
                      fontWeight: nTypographyStyle.titleFontWeight,
                      textColor: nTypographyStyle.titleColor,
                      maxline: nTypographyStyle.titleMaxLine,
                      textStyle: nTypographyStyle.titleTextStyle,
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
