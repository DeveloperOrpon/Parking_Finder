class DivisionModel {
  DivisionModel({
    this.id,
    this.name,
    this.bnName,
    this.url,
  });

  DivisionModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    bnName = json['bn_name'];
    url = json['url'];
  }
  String? id;
  String? name;
  String? bnName;
  String? url;
  DivisionModel copyWith({
    String? id,
    String? name,
    String? bnName,
    String? url,
  }) =>
      DivisionModel(
        id: id ?? this.id,
        name: name ?? this.name,
        bnName: bnName ?? this.bnName,
        url: url ?? this.url,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['bn_name'] = bnName;
    map['url'] = url;
    return map;
  }

  @override
  bool operator ==(dynamic other) =>
      other != null && other is DivisionModel && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
