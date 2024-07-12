import 'package:mesa_ayuda/models/ArchivoAdjunto.dart';
import 'package:mesa_ayuda/models/Seguimiento.dart';

class Ticket {
  late int id;
  late String estatus;
  late String area;
  late String categoria;
  late String sintoma;
  late String usuarioFinal;
  late String folio;
  late String prioridad;
  late String descripcion;
  late int sintomaId;
  late int tipoServicioId;
  late List<Seguimiento> seguimientos = [];
  late List<ArchivoAdjunto> archivos = [];
  late var created_at = "";
  Ticket(this.id, this.estatus, this.area, this.categoria, this.sintoma,
      this.usuarioFinal, this.folio, this.prioridad, this.descripcion);

  Ticket.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        estatus = json['estatus'],
        area = json['area'],
        categoria = json['categoria'],
        sintoma = json['sintoma'],
        usuarioFinal = json['usuarioFinal'],
        folio = json['folio'],
        prioridad = json['prioridad'],
        descripcion = json['descripcion'],
        sintomaId = json['sintomaId'],
        tipoServicioId = json['tipoServicioId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'estatus': estatus,
        'area': area,
        'categoria': categoria,
        'sintoma': sintoma,
        'usuarioFinal': usuarioFinal,
        'folio': folio,
        'prioridad': prioridad,
        'descripcion': descripcion,
        'sintomaId': sintomaId,
        'tipoServicioId': tipoServicioId,
      };
}
