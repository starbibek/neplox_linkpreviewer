library neplox_linkpreviewer;
import 'package:neplox_linkpreviewer/src/fetch_elements/fetch_link.dart';
import 'package:neplox_linkpreviewer/src/link_previewer/link_previewer_index.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';
/// Neplox Link Fetcher.
class NeploxLinkPreviewer {
  ///show Link Preview
  show(String url)=>LinkPreviewer(url: url);
  ///Get Data from Element
  Future<ElementModel>getData(String url)async=>await fetch(url);
}

