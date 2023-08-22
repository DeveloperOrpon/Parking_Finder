
class UserModel {
  UserModel({
      this.payment, 
      this.id, 
      this.profileImage, 
      this.username, 
      this.address, 
      this.nickName, 
      this.phoneNo, 
      this.nidImage, 
      this.licenceImage, 
      this.role, 
      this.isEmailVerified, 
      this.isPhoneVerified, 
      this.dob, 
      this.gender, 
      this.email, 
      this.password, 
      this.vicList, 
      this.garazList, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  UserModel.fromJson(dynamic json) {
    if (json['payment'] != null) {
      payment = [];
      json['payment'].forEach((v) {
        payment?.add((v));
      });
    }
    id = json['_id'];
    profileImage = json['profile_image'];
    username = json['username'];
    address = json['address'];
    nickName = json['nick_name'];
    phoneNo = json['phone_no'];
    nidImage = json['nid_image'];
    licenceImage = json['licence_image'];
    role = json['role'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    dob = json['dob'];
    gender = json['gender'];
    email = json['email'];
    password = json['password'];
    if (json['vic_list'] != null) {
      vicList = [];
      json['vic_list'].forEach((v) {
        vicList?.add(VicList.fromJson(v));
      });
    }
    if (json['garaz_list'] != null) {
      garazList = [];
      json['garaz_list'].forEach((v) {
        garazList?.add(GarageModel.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  List<dynamic>? payment;
  String? id;
  String? profileImage;
  String? username;
  String? address;
  String? nickName;
  String? phoneNo;
  String? nidImage;
  String? licenceImage;
  String? role;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? dob;
  String? gender;
  String? email;
  String? password;
  List<VicList>? vicList;
  List<GarageModel>? garazList;
  String? createdAt;
  String? updatedAt;
  num? v;
  UserModel copyWith({  List<dynamic>? payment,
  String? id,
  String? profileImage,
  String? username,
  String? address,
  String? nickName,
  String? phoneNo,
  String? nidImage,
  String? licenceImage,
  String? role,
  bool? isEmailVerified,
  bool? isPhoneVerified,
  String? dob,
  String? gender,
  String? email,
  String? password,
  List<VicList>? vicList,
  List<GarageModel>? garazList,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => UserModel(  payment: payment ?? this.payment,
  id: id ?? this.id,
  profileImage: profileImage ?? this.profileImage,
  username: username ?? this.username,
  address: address ?? this.address,
  nickName: nickName ?? this.nickName,
  phoneNo: phoneNo ?? this.phoneNo,
  nidImage: nidImage ?? this.nidImage,
  licenceImage: licenceImage ?? this.licenceImage,
  role: role ?? this.role,
  isEmailVerified: isEmailVerified ?? this.isEmailVerified,
  isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
  dob: dob ?? this.dob,
  gender: gender ?? this.gender,
  email: email ?? this.email,
  password: password ?? this.password,
  vicList: vicList ?? this.vicList,
  garazList: garazList ?? this.garazList,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  v: v ?? this.v,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (payment != null) {
      map['payment'] = payment?.map((v) => v.toJson()).toList();
    }
    map['_id'] = id;
    map['profile_image'] = profileImage;
    map['username'] = username;
    map['address'] = address;
    map['nick_name'] = nickName;
    map['phone_no'] = phoneNo;
    map['nid_image'] = nidImage;
    map['licence_image'] = licenceImage;
    map['role'] = role;
    map['isEmailVerified'] = isEmailVerified;
    map['isPhoneVerified'] = isPhoneVerified;
    map['dob'] = dob;
    map['gender'] = gender;
    map['email'] = email;
    map['password'] = password;
    if (vicList != null) {
      map['vic_list'] = vicList?.map((v) => v.toJson()).toList();
    }
    if (garazList != null) {
      map['garaz_list'] = garazList?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}

class GarageModel {
  GarageModel({
      this.gId, 
      this.name, 
      this.facilities, 
      this.totalFloor, 
      this.ownerUId, 
      this.address, 
      this.division, 
      this.availableSpace, 
      this.city, 
      this.parkingAdsPIds, 
      this.rating, 
      this.totalSpace, 
      this.additionalInformation, 
      this.isActive, 
      this.coverImage, 
      this.acceptAdminUId, 
      this.createTime, 
      this.parkingCategoryList,});

  GarageModel.fromJson(dynamic json) {
    gId = json['gId'];
    name = json['name'];
    facilities = json['facilities'] != null ? json['facilities'].cast<String>() : [];
    totalFloor = json['totalFloor'];
    ownerUId = json['ownerUId'];
    address = json['address'];
    division = json['division'];
    availableSpace = json['availableSpace'];
    city = json['city'];
    parkingAdsPIds = json['parkingAdsPIds'];
    rating = json['rating'];
    totalSpace = json['totalSpace'];
    additionalInformation = json['additionalInformation'];
    isActive = json['isActive'];
    coverImage = json['coverImage'] != null ? json['coverImage'].cast<String>() : [];
    acceptAdminUId = json['acceptAdminUId'];
    createTime = json['createTime'];
    if (json['parkingCategoryList'] != null) {
      parkingCategoryList = [];
      json['parkingCategoryList'].forEach((v) {
        parkingCategoryList?.add(v);
      });
    }
  }
  String? gId;
  String? name;
  List<String>? facilities;
  String? totalFloor;
  String? ownerUId;
  String? address;
  String? division;
  String? availableSpace;
  String? city;
  dynamic parkingAdsPIds;
  String? rating;
  String? totalSpace;
  String? additionalInformation;
  bool? isActive;
  List<String>? coverImage;
  String? acceptAdminUId;
  String? createTime;
  List<dynamic>? parkingCategoryList;
GarageModel copyWith({  String? gId,
  String? name,
  List<String>? facilities,
  String? totalFloor,
  String? ownerUId,
  String? address,
  String? division,
  String? availableSpace,
  String? city,
  dynamic parkingAdsPIds,
  String? rating,
  String? totalSpace,
  String? additionalInformation,
  bool? isActive,
  List<String>? coverImage,
  String? acceptAdminUId,
  String? createTime,
  List<dynamic>? parkingCategoryList,
}) => GarageModel(  gId: gId ?? this.gId,
  name: name ?? this.name,
  facilities: facilities ?? this.facilities,
  totalFloor: totalFloor ?? this.totalFloor,
  ownerUId: ownerUId ?? this.ownerUId,
  address: address ?? this.address,
  division: division ?? this.division,
  availableSpace: availableSpace ?? this.availableSpace,
  city: city ?? this.city,
  parkingAdsPIds: parkingAdsPIds ?? this.parkingAdsPIds,
  rating: rating ?? this.rating,
  totalSpace: totalSpace ?? this.totalSpace,
  additionalInformation: additionalInformation ?? this.additionalInformation,
  isActive: isActive ?? this.isActive,
  coverImage: coverImage ?? this.coverImage,
  acceptAdminUId: acceptAdminUId ?? this.acceptAdminUId,
  createTime: createTime ?? this.createTime,
  parkingCategoryList: parkingCategoryList ?? this.parkingCategoryList,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gId'] = gId;
    map['name'] = name;
    map['facilities'] = facilities;
    map['totalFloor'] = totalFloor;
    map['ownerUId'] = ownerUId;
    map['address'] = address;
    map['division'] = division;
    map['availableSpace'] = availableSpace;
    map['city'] = city;
    map['parkingAdsPIds'] = parkingAdsPIds;
    map['rating'] = rating;
    map['totalSpace'] = totalSpace;
    map['additionalInformation'] = additionalInformation;
    map['isActive'] = isActive;
    map['coverImage'] = coverImage;
    map['acceptAdminUId'] = acceptAdminUId;
    map['createTime'] = createTime;
    if (parkingCategoryList != null) {
      map['parkingCategoryList'] = parkingCategoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class VicList {
  VicList({
      this.vId, 
      this.vehicle, 
      this.isDefault, 
      this.plateNumber, 
      this.model, 
      this.vehicleType,});

  VicList.fromJson(dynamic json) {
    vId = json['vId'];
    vehicle = json['vehicle'];
    isDefault = json['isDefault'];
    plateNumber = json['plateNumber'];
    model = json['model'];
    vehicleType = json['vehicleType'];
  }
  String? vId;
  String? vehicle;
  bool? isDefault;
  String? plateNumber;
  String? model;
  String? vehicleType;
VicList copyWith({  String? vId,
  String? vehicle,
  bool? isDefault,
  String? plateNumber,
  String? model,
  String? vehicleType,
}) => VicList(  vId: vId ?? this.vId,
  vehicle: vehicle ?? this.vehicle,
  isDefault: isDefault ?? this.isDefault,
  plateNumber: plateNumber ?? this.plateNumber,
  model: model ?? this.model,
  vehicleType: vehicleType ?? this.vehicleType,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vId'] = vId;
    map['vehicle'] = vehicle;
    map['isDefault'] = isDefault;
    map['plateNumber'] = plateNumber;
    map['model'] = model;
    map['vehicleType'] = vehicleType;
    return map;
  }

}