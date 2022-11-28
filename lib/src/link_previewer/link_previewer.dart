import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/fetch_elements/fetch_link.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';

class LinkPreviewer extends StatelessWidget {
  const LinkPreviewer({super.key,this.url});
  final String? url;
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Material(
      child: FutureBuilder<ElementModel>(
        future: fetch(url!),
        builder: ((context, snapshot) {
        print("This is Neplox Null Element Print ${snapshot.data}");
        if(snapshot.connectionState==ConnectionState.waiting){
          return const CircularProgressIndicator();
        }else if(!snapshot.hasData){
          return const Center(child: Text("Sorry Data Not Available"));
        }
        else{
          return Container(
            constraints: BoxConstraints(
              maxHeight: 0.2 * size.height,
              maxWidth: 1 * size.width,
            ),
            decoration: const BoxDecoration(),
            child: Column(children:  [
              Container(
                constraints: BoxConstraints(
                  maxWidth: 1*size.width,
                  maxHeight: 0.2 *size.height,
                ),
                child:CachedNetworkImage(imageUrl: snapshot.data!.image!,) ,
              ),
            ],),
          );
        }
      })),
    );
  }
}