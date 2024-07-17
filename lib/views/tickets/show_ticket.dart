import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mesa_ayuda/controllers/TicketController.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../controllers/ArchivoController.dart';
import '../../controllers/SeguimientoController.dart';
import '../../controllers/UserController.dart';
import '../../models/Seguimiento.dart';
import '../../models/Ticket.dart';
import '../../models/Usuario.dart';

class ShowTicket extends StatefulWidget {
  Ticket ticket;
  ShowTicket({super.key, required this.ticket});

  @override
  State<ShowTicket> createState() => _ShowTicketState();
}

class _ShowTicketState extends State<ShowTicket> {
  List<ListTile> _segimientos = [];
  List<Widget> lista_adjuntos = [];
  String textoSeguimiento = "";
  Ticket currentTicket = Ticket(0, 'estatus', 'area', 'categoria', 'sintoma',
      'usuarioFinal', 'folio', 'prioridad', 'descripcion');
  String imagePath = "";
  bool adjuntando = false;
  Usuario currentUser = Usuario();
  String estatusEdit = '';
  @override
  void initState() {
    super.initState();
    currentTicket = widget.ticket;
    print(currentTicket);
    llenasSeguimientos(currentTicket.seguimientos);
    _listaArchivosAdjuntos(currentTicket.archivos);
    setState(() {
      _cargarDatosUsuario();
    });
  }

  _cargarDatosUsuario() async {
    currentUser = await UserController().usuarioLogueado();
    setState(() {});
  }

  void llenasSeguimientos(seguimientos) {
    _segimientos = [];
    for (var seguimiento in seguimientos) {
      setState(() {
        _segimientos.add(
          ListTile(
            title: Text(seguimiento.autor,
                style: const TextStyle(
                    color: Color.fromRGBO(7, 121, 84, 1), fontSize: 14.0)),
            subtitle: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(seguimiento.texto),
                Text(
                  seguimiento.createdAt,
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.chat_bubble),
            onTap: () {},
            onLongPress: () {},
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(7, 121, 84, 1),
        title: Text(
          "Folio: ${widget.ticket.folio}",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          (currentUser.rol_id == 1 || currentUser.rol_id == 2)
              ? IconButton(
                  onPressed: () {
                    _verCambiarEstatus(context);
                  },
                  icon: const Icon(Icons.edit))
              : const SizedBox(),
        ],
      ),
      body: SlidingUpPanel(
        minHeight: 40,
        maxHeight: 180,
        color: Colors.transparent,
        body: ticketBody(),
        panel: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Color.fromRGBO(7, 121, 84, 1)),
          child: Column(children: [
            const Icon(
              Icons.drag_handle_rounded,
              color: Colors.white,
            ),
            ElevatedButton(
              onPressed: () {
                _agregarSeguimiento(context);
              },
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble),
                    Text("Agregar seguimiento")
                  ]),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () {
                _adjuntarArchivo(context);
              },
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.image), Text("Adjuntar imagen")]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget ticketBody() {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color.fromRGBO(7, 121, 84, 1),
      strokeWidth: 4.0,
      onRefresh: () async {
        currentTicket =
            await TicketController().apiGetTicket(context, widget.ticket.id);
        llenasSeguimientos(currentTicket.seguimientos);
        _listaArchivosAdjuntos(currentTicket.archivos);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo_ppj.png',
                    height: 180,
                    width: 180,
                  ),
                ),
                const Text(
                  "Prioridad:",
                  style: TextStyle(
                      color: Color.fromRGBO(7, 121, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                Text(currentTicket.prioridad),
                const Text(
                  "Nombre:",
                  style: TextStyle(
                      color: Color.fromRGBO(7, 121, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                Text(currentTicket.usuarioFinal),
                const Text("Estatus:",
                    style: TextStyle(
                        color: Color.fromRGBO(7, 121, 84, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.estatus),
                const Text("Área:",
                    style: TextStyle(
                        color: Color.fromRGBO(7, 121, 84, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.area),
                const Text("Tipo de servicio:",
                    style: TextStyle(
                        color: Color.fromRGBO(7, 121, 84, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.categoria),
                const Text("Descripción:",
                    style: TextStyle(
                        color: Color.fromRGBO(7, 121, 84, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.descripcion),
                const Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Text(
                    "SEGUIMIENTO",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: Divider()),
                ]),
                Column(
                  children: _segimientos.isNotEmpty
                      ? _segimientos
                      : [const Text("Sin seguimiento")],
                ),
                const Row(
                  children: <Widget>[
                    Expanded(child: Divider()),
                    Text(
                      "ADJUNTOS",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                Column(
                  children: (lista_adjuntos.isEmpty)
                      ? [const Text('Sin adjuntos')]
                      : _listaArchivosAdjuntos(currentTicket.archivos),
                ),
                const SizedBox(
                  height: 200,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _listaArchivosAdjuntos(dataArchivos) {
    lista_adjuntos = [];
    for (var archivo in dataArchivos) {
      setState(() {
        lista_adjuntos.add(ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'http://${dotenv.env['SERVER_URL']}${dotenv.env['FILES_PATH']}' +
                    archivo.name),
          ),
          title: Text(archivo.author,
              style: const TextStyle(
                  color: Color.fromRGBO(7, 121, 84, 1), fontSize: 14.0)),
          subtitle: Text(
            archivo.created_at,
            style: const TextStyle(fontSize: 11),
          ),
          trailing: const Icon(Icons.open_in_full),
          onTap: () {
            //print("Ver imagen completa");
            _verImagenCompleta(
                context,
                archivo.name,
                'http://${dotenv.env['SERVER_URL']}${dotenv.env['FILES_PATH']}' +
                    archivo.name);
          },
        ));
      });
      //lista.add(TextButton(onPressed: () {}, child: Text(archivo.name)));
    }
    return lista_adjuntos;
  }

  Future _verImagenCompleta(context, tituto, url) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              tituto,
              style: const TextStyle(
                  color: Color.fromRGBO(7, 121, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(1.0),
                minScale: 0.1,
                //maxScale: 1.6,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(url))),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future _agregarSeguimiento(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Agregar Seguimiento',
              style: TextStyle(
                  color: Color.fromRGBO(7, 121, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      filled: true,
                      fillColor: Color.fromARGB(240, 230, 221, 221),
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(7, 121, 84, 1)),
                      labelText: 'Escriba sus comentarios aquí:',
                    ),
                    onChanged: (value) {
                      textoSeguimiento = value;
                    },
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Enviar',
                  style: TextStyle(
                      color: Color.fromRGBO(7, 121, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                onPressed: () async {
                  if (textoSeguimiento.isEmpty) {
                    mensajes.mensajeFlash(context, "Ingrese el texto...");
                  } else {
                    Seguimiento seguimiento = Seguimiento(
                        0, widget.ticket.id, 'autor', textoSeguimiento, '');
                    if (await SeguimientoController()
                        .apiStoreSeguimiento(context, seguimiento)) {
                      currentTicket = await TicketController()
                          .apiGetTicket(context, widget.ticket.id);
                      llenasSeguimientos(currentTicket.seguimientos);
                      _listaArchivosAdjuntos(currentTicket.archivos);
                      Route route = MaterialPageRoute(
                          builder: (context) =>
                              ShowTicket(ticket: currentTicket));
                      Navigator.pushReplacement(context, route);
                    } else {
                      mensajes.mensajeFlash(
                          context, "Error al procesar información...");
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  Future _adjuntarArchivo(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Adjuntar imagen',
              style: TextStyle(
                  color: Color.fromRGBO(7, 121, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            content: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    // imagePath.isEmpty
                    //     ? Image.asset(
                    //         'assets/icono_imagen.png',
                    //         width: MediaQuery.of(context).size.width / 2,
                    //       )
                    //     : Image.file(
                    //         File(
                    //           imagePath,
                    //         ),
                    //         width: MediaQuery.of(context).size.width / 1.5),
                    ElevatedButton(
                      onPressed: () {
                        _seleccionarArchivoCamara();
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.camera_enhance),
                            Text("Subir desde Cámara")
                          ]),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _seleccionarArchivoGaleria();
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.image_search),
                            Text("Subir desde Galería")
                          ]),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         Icon(Icons.file_open),
                    //         Text("Seleccionar archiivo")
                    //       ]),
                    // ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: adjuntando
                          ? const CircularProgressIndicator(color: Colors.green)
                          : const SizedBox(),
                    )
                  ],
                )),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _seleccionarArchivoCamara() async {
    final ImagePicker picker = ImagePicker();
    try {
      var archivo = await picker.pickImage(source: ImageSource.camera);
      imagePath = archivo!.path;
      List<int> bytes = File(imagePath).readAsBytesSync();
      //print(bytes);
      var imagen64 = base64Encode(bytes);
      var data = {
        'case_id': currentTicket.id.toString(),
        'archivo': imagen64,
      };
      super.setState(() {
        adjuntando = true;
      });

      if (await ArchivoController().apiAdjuntarArchivo(context, data)) {
        currentTicket =
            await TicketController().apiGetTicket(context, widget.ticket.id);
        _listaArchivosAdjuntos(currentTicket.archivos);
        Navigator.pop(context);
        super.setState(() {
          adjuntando = false;
        });
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  _seleccionarArchivoGaleria() async {
    final ImagePicker picker = ImagePicker();
    try {
      var archivo = await picker.pickImage(source: ImageSource.gallery);
      imagePath = archivo!.path;
      List<int> bytes = File(imagePath).readAsBytesSync();
      //print(bytes);
      var imagen64 = base64Encode(bytes);
      var data = {
        'case_id': currentTicket.id.toString(),
        'archivo': imagen64,
      };
      super.setState(() {
        adjuntando = true;
      });

      if (await ArchivoController().apiAdjuntarArchivo(context, data)) {
        currentTicket =
            await TicketController().apiGetTicket(context, widget.ticket.id);
        _listaArchivosAdjuntos(currentTicket.archivos);
        Navigator.pop(context);
        super.setState(() {
          adjuntando = false;
        });
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future _verCambiarEstatus(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Cambiar estatus',
              style: TextStyle(
                  color: Color.fromRGBO(7, 121, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  filled: true,
                  fillColor: Color.fromARGB(240, 230, 221, 221),
                  labelText: "Estatus",
                  labelStyle: TextStyle(color: Color.fromRGBO(7, 121, 84, 1)),
                ),
                value: currentTicket.estatus,
                items: const [
                  DropdownMenuItem<String>(
                    value: "Pendiente",
                    child: Text(
                      "Pendiente",
                      style: TextStyle(
                        color: Color.fromRGBO(7, 121, 84, 1),
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "En progreso",
                    child: Text(
                      "En progreso",
                      style: TextStyle(
                        color: Color.fromRGBO(7, 121, 84, 1),
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "Cerrada",
                    child: Text(
                      "Cerrada",
                      style: TextStyle(
                        color: Color.fromRGBO(7, 121, 84, 1),
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    estatusEdit = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona el estatus';
                  }
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Actualizar',
                  style: TextStyle(
                      color: Color.fromRGBO(7, 121, 84, 1),
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (await TicketController().apiactualizarEstatusTicket(
                      context, currentTicket.id, estatusEdit)) {
                    currentTicket = await TicketController()
                        .apiGetTicket(context, widget.ticket.id);
                    llenasSeguimientos(currentTicket.seguimientos);
                    _listaArchivosAdjuntos(currentTicket.archivos);
                    Navigator.pop(context);
                  } else {
                    print("Fail");
                  }
                },
              ),
            ],
          );
        });
  }
}
