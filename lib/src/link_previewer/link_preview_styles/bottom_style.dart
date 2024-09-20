import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'style/styles.dart';
import 'widgets/text_widgets.dart';

/// [BottomPreviewStyle] is a StatelessWidget that displays title, body and image accordingly.
/// <summary>
/// [snapshot] is the data of the link you want to preview
/// [linkPreviewOptions] is the options you want to set for the link preview
/// [nTypographyStyle] is the typography style for title and body text
class BottomPreviewStyle extends StatelessWidget {
  /// Bottom preview style Constructor
  const BottomPreviewStyle({
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
            minWidth: 0.5 * MediaQuery.of(context).size.width,
            minHeight: 0.05 * MediaQuery.of(context).size.height,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerTextWidget(
                      context,
                      "${snapshot.title}",
                      fontSize: nTypographyStyle.titleFontSize,
                      fontWeight: nTypographyStyle.titleFontWeight,
                      textColor: nTypographyStyle.titleColor,
                      maxline: nTypographyStyle.titleMaxLine,
                      textStyle: nTypographyStyle.titleTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
              Container(
                constraints: BoxConstraints(
                  maxHeight: 0.2 * MediaQuery.of(context).size.height,
                  minWidth: double.infinity,
                ),
                child: Image.network(
                  "${snapshot.image}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text("Cannot Retrieved Image From Url"),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if ((loadingProgress?.cumulativeBytesLoaded ?? 0) >=
                        (loadingProgress?.expectedTotalBytes ?? 0)) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator.adaptive(
                          value: loadingProgress?.cumulativeBytesLoaded
                              .roundToDouble(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
