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
  int tipoServicioId = 0;
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(7, 121, 84, 1),
        title: Text("Iniciar Caso", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                if (tipoServicioId > 0) {
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
                  ticket.tipoServicioId = tipoServicioId;
                  ticket.prioridad = prioridad;
                  ticket.descripcion = descripcion;
                  if (await TicketController()
                      .apiStoreTicket(context, ticket)) {
                    Navigator.pop(context);
                  }
                } else {
                  mensajes.mensajeFlash(
                      context, "Por favor selecciona Área y tipo se servicio");
                }
              }
            },
            icon: Icon(Icons.save),
            color: Colors.white,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/restaurant_wallpaper.jpg'),
              fit: BoxFit.cover,
              opacity: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Area
                DropdownButtonFormField(
                  //SELECT AREAS
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Color.fromARGB(240, 230, 221, 221),
                    labelText: "Área",
                    labelStyle: TextStyle(color: Color.fromRGBO(7, 121, 84, 1)),
                  ),
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
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(7, 121, 84, 1),
                          fontSize: 13.0,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (Object? value) {},
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  //SELECT TIPOS SERVICIO (categorias)
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Color.fromARGB(240, 230, 221, 221),
                    labelText: "Tipo de servicio",
                    labelStyle: TextStyle(color: Color.fromRGBO(7, 121, 84, 1)),
                  ),
                  value: categoria,
                  items: categorias.map((Categoria tipoServicio) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        tipoServicioId = tipoServicio.id;
                      },
                      value: tipoServicio.categoria,
                      child: Text(
                        tipoServicio.categoria,
                        style: TextStyle(
                          color: Color.fromRGBO(7, 121, 84, 1),
                          fontSize: 13.0,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (Object? value) {},
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Color.fromARGB(240, 230, 221, 221),
                    labelText: "Prioridad",
                    labelStyle: TextStyle(color: Color.fromRGBO(7, 121, 84, 1)),
                  ),
                  value: prioridad,
                  items: prioridades.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Color.fromRGBO(7, 121, 84, 1),
                          fontSize: 13.0,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      prioridad = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor selecciona la prioridad';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Color.fromARGB(240, 230, 221, 221),
                    labelStyle: TextStyle(color: Color.fromRGBO(7, 121, 84, 1)),
                    labelText: 'Descripción',
                  ),
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
      ),
    );
  }
}
