import 'package:shared_preferences/shared_preferences.dart';

const String searchList = 'searchLists';

Future<bool> setSearchList(List<String> value) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setStringList(searchList, value);
}

Future<List<String>> getSearchList() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getStringList(searchList) ?? [];
}
