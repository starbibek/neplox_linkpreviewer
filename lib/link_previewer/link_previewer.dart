import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/fetch_elements/fetch_link.dart';

class LinkPreviewer extends StatelessWidget {
  const LinkPreviewer({super.key,this.url});
  final String? url;
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Material(
      child: FutureBuilder(
        future: fetch(url!),
        builder: ((context, snapshot) {
        if(!snapshot.hasData){
          return const CircularProgressIndicator();
        }else{
          return Container(
            constraints: BoxConstraints(
              maxHeight: 0.05 * size.height,
              maxWidth: 0.5 * size.width,
            ),
            decoration: const BoxDecoration(),
            child: Column(children: const [],),
          );
        }
      })),
    );
  }
}