import 'package:cached_network_image/cached_network_image.dart';
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
            child: Column(children:  [
              Container(
                constraints: BoxConstraints(
                  maxWidth: 0.5*size.width,
                  maxHeight: 0.05 *size.height,
                ),
                child:CachedNetworkImage(imageUrl: snapshot.data[0]['image'],) ,
              ),
            ],),
          );
        }
      })),
    );
  }
}