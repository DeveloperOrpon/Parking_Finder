class UserModel {
  UserModel({
      this.id, 
      this.userinfo, 
      this.email, 
      this.password, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  UserModel.fromJson(dynamic json) {
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
UserModel copyWith({  String? id,
  List<Userinfo>? userinfo,
  String? email,
  String? password,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => UserModel(  id: id ?? this.id,
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

class Userinfo {
  Userinfo({
      this.profileImage, 
      this.username, 
      this.contNo, 
      this.nidImage, 
      this.licenceImage, 
      this.role, 
      this.isEmailVerified, 
      this.isPhoneVerified, 
      this.dob, 
      this.gender, 
      this.id,});

  Userinfo.fromJson(dynamic json) {
    profileImage = json['profile_image'];
    username = json['username'];
    contNo = json['cont_no'];
    nidImage = json['nid_image'];
    licenceImage = json['licence_image'];
    role = json['role'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    dob = json['dob'];
    gender = json['gender'];
    id = json['_id'];
  }
  String? profileImage;
  String? username;
  String? contNo;
  String? nidImage;
  String? licenceImage;
  String? role;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? dob;
  String? gender;
  String? id;
Userinfo copyWith({  String? profileImage,
  String? username,
  String? contNo,
  String? nidImage,
  String? licenceImage,
  String? role,
  bool? isEmailVerified,
  bool? isPhoneVerified,
  String? dob,
  String? gender,
  String? id,
}) => Userinfo(  profileImage: profileImage ?? this.profileImage,
  username: username ?? this.username,
  contNo: contNo ?? this.contNo,
  nidImage: nidImage ?? this.nidImage,
  licenceImage: licenceImage ?? this.licenceImage,
  role: role ?? this.role,
  isEmailVerified: isEmailVerified ?? this.isEmailVerified,
  isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
  dob: dob ?? this.dob,
  gender: gender ?? this.gender,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profile_image'] = profileImage;
    map['username'] = username;
    map['cont_no'] = contNo;
    map['nid_image'] = nidImage;
    map['licence_image'] = licenceImage;
    map['role'] = role;
    map['isEmailVerified'] = isEmailVerified;
    map['isPhoneVerified'] = isPhoneVerified;
    map['dob'] = dob;
    map['gender'] = gender;
    map['_id'] = id;
    return map;
  }

}