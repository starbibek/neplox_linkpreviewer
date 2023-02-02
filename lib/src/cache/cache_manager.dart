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
    var data = elementModelToJson(cache);
    prefs?.setString("${cache.link}", data);
  }
// END set Meta Data Cache.

// BEGIN getCached Meta Data.
  getCache(String link) {
    String data = (prefs?.getString(link) ?? "").toString();
    if (data != "") {
      ElementModel cache = elementModelFromJson(data);
      return cache;
    } else {
      return ElementModel();
    }
  }
// END getCached Meta Data.

}

// END NCacheManager.