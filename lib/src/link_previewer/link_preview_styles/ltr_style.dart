import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';

import 'widgets/text_widgets.dart';

class LTRPreviewStyle extends StatelessWidget {
  const LTRPreviewStyle({super.key, required this.snapshot,required this.linkPreviewOptions});
  final ElementModel snapshot;
   final NLinkPreviewOptions linkPreviewOptions;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 0.3.sw(context),
            height: 0.35.sw(context),
            child: Image.network(
              snapshot.image ?? "",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 0.6.sw(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: headerTextWidget(
                      context, "${snapshot.title}".capitalize()),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: bodyTextWidget(context, "${snapshot.description}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
