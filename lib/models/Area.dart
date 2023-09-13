class Area {
  late int id;
  late String area;

  Area(this.id, this.area);

  Area.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        area = json['area'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'area': area,
      };
}
