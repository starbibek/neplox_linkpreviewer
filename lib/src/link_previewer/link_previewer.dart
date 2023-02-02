import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';
import 'package:neplox_linkpreviewer/src/fetch_elements/fetch_link.dart';
import 'package:neplox_linkpreviewer/src/helper/helpers.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';
import 'link_preview_styles/style_index.dart';

class NeploxLinkPreviewer extends StatefulWidget {
  NeploxLinkPreviewer({
    super.key,
    required this.url,
    NLinkPreviewOptions? linkPreviewOptions,
  }) : linkPreviewOptions = linkPreviewOptions ?? NLinkPreviewOptions();

  /// [url] is the url of the link you want to preview
  final String url;

  /// [linkPreviewOptions] is the options you want to set for the link preview
  final NLinkPreviewOptions linkPreviewOptions;

  @override
  State<NeploxLinkPreviewer> createState() => _NeploxLinkPreviewerState();
}

class _NeploxLinkPreviewerState extends State<NeploxLinkPreviewer> {
  late final lotsOfData = Future.wait(
    [
      getData(),
    ],
  );
  @override
  void initState() {
    cacheManager.init();

    super.initState();
  }

  Future<ElementModel> getData() async {
    return await nfetch(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<List<ElementModel>>(
          future: lotsOfData,
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Center(child: Text("........"));
              case ConnectionState.done:
                switch (widget.linkPreviewOptions.thumbnailPreviewDirection) {
                  case NThumbnailPreviewDirection.rtl:
                    return RTLPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                    );
                  case NThumbnailPreviewDirection.ltr:
                    return LTRPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                    );
                  case NThumbnailPreviewDirection.top:
                    return TopPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                    );
                  case NThumbnailPreviewDirection.bottom:
                    return BottomPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                    );
                  case NThumbnailPreviewDirection.none:
                    return NonePreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                    );
                }
            }
          })),
    );
  }
}
