import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';

class LinkPreviwer extends StatefulWidget {
  const LinkPreviwer({super.key, required this.url});
  final String url;

  @override
  State<LinkPreviwer> createState() => _LinkPreviwerState();
}

class _LinkPreviwerState extends State<LinkPreviwer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: NeploxLinkPreviewer(
        url: widget.url,
        linkPreviewOptions: NLinkPreviewOptions(
            urlContentType: NURLContentType.video,
            urlLaunch: NURLLaunch.enable,
            urlLaunchIn: NURLLaunchIn.browser,
            thumbnailPreviewDirection: NThumbnailPreviewDirection.bottom),
      ),
    );
  }
}
