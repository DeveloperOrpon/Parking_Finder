import 'package:shared_preferences/shared_preferences.dart';

const String onboardingStatus = 'onboarding';
const String isLogin = 'isLogin';
const String loginJWTToken = 'loginJWTToken';
const String userInfo = 'userInfo';

Future<bool> setOnboardingStatus(bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool(onboardingStatus, status);
}

Future<bool> getOnboardingStatus() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool(onboardingStatus) ?? false;
}

Future<bool> setLoginStatus(bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool(isLogin, status);
}

Future<bool> getLoginStatus() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool(isLogin) ?? false;
}

Future<bool> setJWTToken(String jwtToken) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setString(loginJWTToken, jwtToken);
}

Future<String> getJWTToken() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getString(loginJWTToken)!;
}

Future<bool> setUserInfo(String info) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setString(userInfo, info);
}

Future<String> getUserInfo() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getString(userInfo)!;
}
