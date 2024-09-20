import 'dart:convert';

import 'package:neplox_linkpreviewer/src/model/element_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// this cache manager Instance
NCacheManager cacheManager = NCacheManager.instance;

// BEGIN NCacheManager.
class NCacheManager {
  // BEGIN private constructor.
  NCacheManager._();
  static NCacheManager instance = NCacheManager._();
  // END private constructor.

  SharedPreferences? prefs;
// BEGIN init shared Preference.
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
// END init shared Preference.

// BEGIN set Meta Data Cache.
  void setCache(ElementModel cache) {
    var data = ElementModel.elementModelToJson(cache);
    prefs?.setString("${cache.link}", data);
  }
// END set Meta Data Cache.

// BEGIN getCached Meta Data.
  ElementModel getCache(String link) {
    try {
      String data = (prefs?.getString(link) ?? "").toString();
      if (data != "") {
        ElementModel cache = ElementModel.fromJson(jsonDecode(data.toString()));
        return cache;
      } else {
        return ElementModel.empty();
      }
    } catch (ex) {
      print("Error while getting cache: $ex");
      return ElementModel.empty();
    }
  }
// END getCached Meta Data.
}

// END NCacheManager.
