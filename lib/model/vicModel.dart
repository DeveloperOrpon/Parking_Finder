class VicModel {
  VicModel({
    this.vId,
    this.vehicle,
    this.isDefault,
    this.plateNumber,
    this.model,
    this.vehicleType,
  });

  VicModel.fromJson(dynamic json) {
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
  VicModel copyWith({
    String? vId,
    String? vehicle,
    bool? isDefault,
    String? plateNumber,
    String? model,
    String? vehicleType,
  }) =>
      VicModel(
        vId: vId ?? this.vId,
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
