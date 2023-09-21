class Seguimiento {
  late int id;
  late int ticketId;
  late String autor;
  late String texto;
  late String createdAt;

  Seguimiento(this.id, this.ticketId, this.autor, this.texto, this.createdAt);

  Seguimiento.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        ticketId = json['ticketId'],
        autor = json['autor'],
        texto = json['texto'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'ticketId': ticketId,
        'autor': autor,
        'texto': texto,
        'createdAt': createdAt,
      };
}
