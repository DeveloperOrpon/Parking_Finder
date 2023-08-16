import 'package:parking_finder/model/user_model.dart';

class UserResponse {
  UserResponse({
    this.isExist,
    this.token,
  });

  UserResponse.fromJson(dynamic json) {
    isExist =
        json['isExist'] != null ? IsExist.fromJson(json['isExist']) : null;
    token = json['token'];
  }
  IsExist? isExist;
  String? token;
  UserResponse copyWith({
    IsExist? isExist,
    String? token,
  }) =>
      UserResponse(
        isExist: isExist ?? this.isExist,
        token: token ?? this.token,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (isExist != null) {
      map['isExist'] = isExist?.toJson();
    }
    map['token'] = token;
    return map;
  }
}

class IsExist {
  IsExist({
    this.id,
    this.userinfo,
    this.email,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  IsExist.fromJson(dynamic json) {
    id = json['_id'];
    if (json['userinfo'] != null) {
      userinfo = [];
      json['userinfo'].forEach((v) {
        userinfo?.add(Userinfo.fromJson(v));
      });
    }
    email = json['email'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  List<Userinfo>? userinfo;
  String? email;
  String? password;
  String? createdAt;
  String? updatedAt;
  num? v;
  IsExist copyWith({
    String? id,
    List<Userinfo>? userinfo,
    String? email,
    String? password,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      IsExist(
        id: id ?? this.id,
        userinfo: userinfo ?? this.userinfo,
        email: email ?? this.email,
        password: password ?? this.password,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (userinfo != null) {
      map['userinfo'] = userinfo?.map((v) => v.toJson()).toList();
    }
    map['email'] = email;
    map['password'] = password;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}
