class Usuario {
  late int id = 0;
  late int rol_id = 0;
  late int cliente_id = 0;
  late String estatus = '';
  late String nombre = '';
  late String apaterno = '';
  late String amaterno = '';
  late String telefono = '';
  late String telefono_emergencia = '';
  late String email = '';
  late String direccion = '';
  late String imagen = '';

  Usuario();

  Usuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        rol_id = json['rol_id'] ?? 0,
        cliente_id = json['cliente_id'] ?? 0,
        estatus = json['estatus'] ?? '',
        nombre = json['nombre'] ?? '',
        apaterno = json['apaterno'] ?? '',
        amaterno = json['amaterno'] ?? '',
        telefono = json['telefono'] ?? '',
        telefono_emergencia = json['telefono_emergencia'] ?? '',
        email = json['email'] ?? '',
        direccion = json['direccion'] ?? '',
        imagen = json['imagen'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'rol_id': rol_id,
        'cliente_id': cliente_id,
        'estatus': estatus,
        'nombre': nombre,
        'apaterno': apaterno,
        'amaterno': amaterno,
        'telefono': telefono,
        'telefono_emergencia': telefono_emergencia,
        'email': email,
        'direccion': direccion,
        'imagen': imagen,
      };
}
