import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:neplox_linkpreviewer/src/link_previewer/link_preview_styles/widgets/text_widgets.dart';

class NonePreviewStyle extends StatelessWidget {
  const NonePreviewStyle(
      {super.key, required this.snapshot, required this.linkPreviewOptions});
  final ElementModel snapshot;
  final NLinkPreviewOptions linkPreviewOptions;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(
          minWidth: 0.5.sw(context),
          minHeight: 0.05.sh(context),
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
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
    );
  }
}