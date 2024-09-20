import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'style/styles.dart';
import 'widgets/text_widgets.dart';

class LTRPreviewStyle extends StatelessWidget {
  const LTRPreviewStyle({
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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0.5 * MediaQuery.of(context).size.width,
            minHeight: 0.05 * MediaQuery.of(context).size.height,
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
                          "${snapshot.title}",
                          fontSize: nTypographyStyle.titleFontSize,
                          fontWeight: nTypographyStyle.titleFontWeight,
                          textColor: nTypographyStyle.titleColor,
                          maxline: nTypographyStyle.titleMaxLine,
                          textStyle: nTypographyStyle.titleTextStyle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0.004.sres(context)),
                        child: bodyTextWidget(
                          context,
                          "${snapshot.description}",
                          fontSize: nTypographyStyle.bodyFontSize,
                          fontWeight: nTypographyStyle.bodyFontWeight,
                          textColor: nTypographyStyle.bodyColor,
                          maxline: nTypographyStyle.bodyMaxLine,
                          textStyle: nTypographyStyle.bodyTextStyle,
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
