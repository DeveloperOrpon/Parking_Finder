class CityModel {
  CityModel({
    this.id,
    this.divisionId,
    this.name,
    this.bnName,
    this.lat,
    this.lon,
    this.url,
  });

  CityModel.fromJson(dynamic json) {
    id = json['id'];
    divisionId = json['division_id'];
    name = json['name'];
    bnName = json['bn_name'];
    lat = json['lat'];
    lon = json['lon'];
    url = json['url'];
  }
  String? id;
  String? divisionId;
  String? name;
  String? bnName;
  String? lat;
  String? lon;
  String? url;
  CityModel copyWith({
    String? id,
    String? divisionId,
    String? name,
    String? bnName,
    String? lat,
    String? lon,
    String? url,
  }) =>
      CityModel(
        id: id ?? this.id,
        divisionId: divisionId ?? this.divisionId,
        name: name ?? this.name,
        bnName: bnName ?? this.bnName,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        url: url ?? this.url,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['division_id'] = divisionId;
    map['name'] = name;
    map['bn_name'] = bnName;
    map['lat'] = lat;
    map['lon'] = lon;
    map['url'] = url;
    return map;
  }

  @override
  bool operator ==(dynamic other) =>
      other != null && other is CityModel && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
