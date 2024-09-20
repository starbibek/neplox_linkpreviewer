import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'style/styles.dart';
import 'widgets/text_widgets.dart';

class TopPreviewStyle extends StatelessWidget {
  const TopPreviewStyle({
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
                try {
                  launchUrl(Uri.parse(snapshot.link ?? ""),
                      mode: linkPreviewOptions.urlLaunchIn == NURLLaunchIn.app
                          ? LaunchMode.inAppWebView
                          : LaunchMode.externalApplication);
                } catch (E) {
                  log(E.toString(), name: "NeploxLinkPreviewer");
                }
              }
            : null,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 0.5.sw(context),
            minHeight: 0.05.sh(context),
          ),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            children: [
              Container(
                  constraints: BoxConstraints(
                    maxHeight: 0.2.sh(context),
                    minWidth: double.infinity,
                  ),
                  child: Image.network(
                    "${snapshot.image}",
                    fit: BoxFit.cover,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerTextWidget(
                      context,
                      "${snapshot.description}",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
