class MapRouteResponse {
  MapRouteResponse({
      this.coordinates, 
      this.type,});

  MapRouteResponse.fromJson(dynamic json) {
    coordinates = json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
    type = json['type'];
  }
  List<List<num>>? coordinates;
  String? type;
MapRouteResponse copyWith({  List<List<num>>? coordinates,
  String? type,
}) => MapRouteResponse(  coordinates: coordinates ?? this.coordinates,
  type: type ?? this.type,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coordinates'] = coordinates;
    map['type'] = type;
    return map;
  }

}