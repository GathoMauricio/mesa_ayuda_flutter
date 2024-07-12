class ArchivoAdjunto {
  late int id;
  late int case_id;
  late String author;
  late String name;
  late String route;
  late String mime_type;
  late String created_at;

  ArchivoAdjunto(this.id, this.case_id, this.author, this.name, this.route,
      this.mime_type, this.created_at);

  ArchivoAdjunto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        case_id = json['case_id'],
        author = json['author'],
        name = json['name'],
        route = json['route'],
        mime_type = json['mime_type'],
        created_at = json['created_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'case_id': case_id,
        'author': author,
        'name': name,
        'route': route,
        'mime_type': mime_type,
        'created_at': created_at
      };
}
