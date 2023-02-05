import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'widgets/text_widgets.dart';

class TopPreviewStyle extends StatelessWidget {
  const TopPreviewStyle(
      {super.key, required this.snapshot, required this.linkPreviewOptions});
  final ElementModel snapshot;
  final NLinkPreviewOptions linkPreviewOptions;
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
                    headerTextWidget(context, "${snapshot.title}"),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: bodyTextWidget(context, "${snapshot.description}"),
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
