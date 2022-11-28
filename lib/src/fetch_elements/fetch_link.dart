
import '../model/element_model.dart';
import 'fetch_link_method.dart';

Future<ElementModel> fetch(String url){
  return fetchElements(url);
}