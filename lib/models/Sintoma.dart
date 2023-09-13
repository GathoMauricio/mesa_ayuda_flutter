class Sintoma {
  late int id;
  late String sintoma;

  Sintoma(this.id, this.sintoma);

  Sintoma.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sintoma = json['sintoma'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoria': sintoma,
      };
}
