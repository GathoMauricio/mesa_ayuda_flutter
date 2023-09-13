class Categoria {
  late int id;
  late String categoria;

  Categoria(this.id, this.categoria);

  Categoria.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        categoria = json['categoria'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoria': categoria,
      };
}
