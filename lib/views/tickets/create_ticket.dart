import 'package:flutter/material.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;
import '../../controllers/AreaController.dart';
import '../../controllers/CategoriaController.dart';
import '../../controllers/SintomaController.dart';
import '../../controllers/TicketController.dart';
import '../../models/Area.dart';
import '../../models/Categoria.dart';
import '../../models/Sintoma.dart';
import '../../models/Ticket.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key});

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final _formKey = GlobalKey<FormState>();
  List<Area> areas = [Area(0, "--Seleccione una opción--")];
  List<Categoria> categorias = [Categoria(0, "--Seleccione una opción--")];
  List<Sintoma> sintomas = [Sintoma(0, "--Seleccione una opción--")];
  List<String> prioridades = ['Baja', 'Media', 'Alta', 'Urgente'];
  String area = "";
  String categoria = "";
  String sintoma = "";

  int sintomaId = 0;
  String prioridad = "";
  String descripcion = "";

  @override
  void initState() {
    super.initState();
    area = areas[0].area;
    categoria = categorias[0].categoria;
    sintoma = sintomas[0].sintoma;
    prioridad = prioridades[0];
    _obtenerAreas();
  }

  void _obtenerAreas() async {
    areas = await AreaController().apiObtenerAreas();
    area = areas[0].area;
    setState(() {});
  }

  void _otenerCategorias(areaId) async {
    categorias =
        await CategoriaController().apiObtenerCategoriasPorArea(areaId);
    categoria = categorias[0].categoria;
    setState(() {});
  }

  void _otenerSintomas(categoria_id) async {
    sintomas =
        await SintomaController().apiObtenerSintomasPorCategoria(categoria_id);
    sintoma = sintomas[0].sintoma;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Iniciar Ticket", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                if (sintomaId > 0) {
                  print("Enviar petición");
                  Ticket ticket = Ticket(
                      0,
                      "estatus",
                      "area",
                      "categoria",
                      "sintoma",
                      "usuarioFinal",
                      "folio",
                      "prioridad",
                      "descripcion");
                  ticket.sintomaId = sintomaId;
                  ticket.prioridad = prioridad;
                  ticket.descripcion = descripcion;
                  if (await TicketController()
                      .apiStoreTicket(context, ticket)) {
                    Navigator.pop(context);
                  }
                } else {
                  mensajes.mensajeFlash(context,
                      "Por favor selecciona Área, Categoría y Sintoma");
                }
              }
            },
            icon: Icon(Icons.save),
            color: Colors.white,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Area
              DropdownButtonFormField(
                //SELECT AREAS
                decoration: InputDecoration(labelText: 'Área'),
                value: area,
                items: areas.map((Area area) {
                  return DropdownMenuItem<String>(
                    onTap: () {
                      setState(() {
                        categorias = [
                          Categoria(0, "--Seleccione una opción--")
                        ];
                        categoria = categorias[0].categoria;
                        sintomas = [Sintoma(0, "--Seleccione una opción--")];
                        sintoma = sintomas[0].sintoma;
                      });
                      if (area.id > 0) {
                        _otenerCategorias(area.id);
                      }
                    },
                    value: area.area,
                    child: Text(
                      area.area,
                      style: TextStyle(color: Colors.blue),
                    ),
                  );
                }).toList(),
                onChanged: (Object? value) {},
              ),
              DropdownButtonFormField(
                //SELECT CATEGORIAS
                decoration: InputDecoration(labelText: 'Categoría'),
                value: categoria,
                items: categorias.map((Categoria categoria) {
                  return DropdownMenuItem<String>(
                    onTap: () {
                      setState(() {
                        sintomas = [Sintoma(0, "--Seleccione una opción--")];
                        sintoma = sintomas[0].sintoma;
                      });
                      if (categoria.id > 0) {
                        _otenerSintomas(categoria.id);
                      }
                    },
                    value: categoria.categoria,
                    child: Text(
                      categoria.categoria,
                      style: TextStyle(color: Colors.blue),
                    ),
                  );
                }).toList(),
                onChanged: (Object? value) {},
              ),
              DropdownButtonFormField(
                //SELECT SINTOMAS
                decoration: InputDecoration(labelText: 'Sintomas'),
                value: sintoma,
                items: sintomas.map((Sintoma sintoma) {
                  return DropdownMenuItem<String>(
                    onTap: () {
                      sintomaId = sintoma.id;
                    },
                    value: sintoma.sintoma,
                    child: Text(
                      sintoma.sintoma,
                      style: TextStyle(color: Colors.blue),
                    ),
                  );
                }).toList(),
                onChanged: (Object? value) {},
              ),
              DropdownButtonFormField(
                value: prioridad,
                items: prioridades.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    prioridad = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Prioridad'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona la prioridad';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa la descripción';
                  }
                  return null;
                },
                onSaved: (value) {
                  descripcion = value!;
                },
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
