import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mesa_ayuda/controllers/AreaController.dart';
import 'package:mesa_ayuda/controllers/HomeController.dart';
import 'package:mesa_ayuda/controllers/UserController.dart';
import 'package:mesa_ayuda/models/Ticket.dart';
import 'package:mesa_ayuda/views/auth/login.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;
import 'package:mesa_ayuda/views/tickets/create_ticket.dart';
import 'package:mesa_ayuda/views/tickets/show_ticket.dart';
import 'package:filter_list/filter_list.dart';
import 'package:intl/intl.dart';

import '../models/Area.dart';
import '../models/Usuario.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  List<Ticket> _listadoTickets = [];
  List<Area> _areasList = [];
  List<Area> selectedAreaList = [];
  Usuario currentUser = Usuario();
  String currentPassword = "";
  String newPassword = "";
  String confirmPassword = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      _cargarTickets();
      _cargarDatosUsuario();
      _cargarAreas();
    });
  }

  _cargarTickets() async {
    _listadoTickets = await HomeController().apiHome(selectedAreaList);
    setState(() {});
  }

  _cargarDatosUsuario() async {
    currentUser = await UserController().usuarioLogueado();
    setState(() {});
  }

  _cargarAreas() async {
    _areasList = await AreaController().apiObtenerAreas();
  }

  void openFilterDialog() async {
    await FilterListDialog.display<Area>(
      headlineText: "Seleccionar áreas",
      hideSearchField: false,
      height: MediaQuery.of(context).size.height / 0.5,
      context,
      listData: _areasList,
      selectedListData: selectedAreaList,
      choiceChipLabel: (area) => area!.area,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (area, query) {
        return area.area.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedAreaList = List.from(list!);
          _cargarTickets();
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: UserController().getUserImage(currentUser.imagen),
                  fit: BoxFit.cover,
                  opacity: 0.9,
                ),
                //color: Color.fromRGBO(7, 121, 84, 1),
              ),
              accountName: Text(
                '${currentUser.nombre} ${currentUser.amaterno}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                "${currentUser.email}\n${UserController().getRolName(currentUser.rol_id)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.account_circle),
            //   title: const Text(
            //     'Cuenta',
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            //   onTap: () {},
            // ),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _cambiarPassword(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text(
                'Actualización',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                var hayNuevaVersion = await HomeController().hayNuevaVersion()
                    as Map<String, dynamic>;

                if (hayNuevaVersion['estatus']) {
                  mensajes.mensajeNuevaVersion(
                      context,
                      "Versión disponible: ${hayNuevaVersion['version'].toString().replaceAll("_", ".")}",
                      "Actualmente se ejecuta la versión ${dotenv.env['APP_VERSION'].toString().replaceAll("_", ".")} le sugerimos descargar la versión más reciente.",
                      hayNuevaVersion['version']);
                } else {
                  mensajes.mensajeNuevaVersion(
                      context,
                      "Última versión: ${hayNuevaVersion['version'].toString().replaceAll("_", ".")}",
                      "Actualmente se ejecuta la versión ${dotenv.env['APP_VERSION'].toString().replaceAll("_", ".")} \n¿Desea dergargarla de todas formas?.",
                      hayNuevaVersion['version']);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _mensajeLogout();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(7, 121, 84, 1),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CreateTicket(),
          ));
        },
        label: const Text(
          'Iniciar Caso',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                openFilterDialog();
              },
              icon: const Icon(Icons.filter_list))
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(7, 121, 84, 1),
        title: const Text(
          "Casos",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: const Color.fromRGBO(7, 121, 84, 1),
        strokeWidth: 4.0,
        onRefresh: () async {
          mensajes.mensajeFlash(context, "Actualizando información.");
          setState(() {
            //_listadoTickets = HomeController().apiHome();
            _cargarTickets();
            mensajes.quitarMensajeFlash(context);
            mensajes.mensajeFlash(context, "Información actualizada.");
          });
        },
        child: ListView(
          children: _listarTickets().cast(),
        ),
        // child: FutureBuilder(
        //   future: _listadoTickets,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return ListView(
        //         children: _listarTickets(snapshot.data as List<Ticket>),
        //       );
        //     } else if (snapshot.hasError) {
        //       //print(snapshot.error);
        //       return Text("Hay error");
        //     }
        //     return const Center(child: CircularProgressIndicator());
        //   },
        // ),
      ),
    );
  }

  List _listarTickets() {
    var listaTickets = [];
    for (var item in _listadoTickets) {
      print(item);
      listaTickets.add(ListTile(
        title: Column(
          children: [
            Text(
              item.area,
              style: const TextStyle(
                  color: Color.fromRGBO(7, 121, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 11.0),
            ),
            Text(
              item.usuarioFinal,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0),
            ),
          ],
        ),
        subtitle: Column(
          children: [
            Text(item.descripcion, style: const TextStyle(fontSize: 12.0)),
            Text(
                DateFormat('yyyy-MM-dd – hh:mm')
                    .format(DateTime.parse(item.created_at)),
                style: const TextStyle(color: Colors.blueGrey, fontSize: 10.0)),
          ],
        ),
        leading: Column(
          children: [
            Text(
              item.folio,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            Text(
              item.estatus,
              style: const TextStyle(fontSize: 8),
            )
            // (item.estatus == 'Pendiente')
            //     ? const Icon(
            //         Icons.pause,
            //         color: Colors.grey,
            //       )
            //     : const Icon(
            //         Icons.play_arrow,
            //         color: Colors.orange,
            //       ),
          ],
        ), //_iconoPrioridad(item.prioridad),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowTicket(
              ticket: item,
            ),
          ));
        },
        onLongPress: () {
          _previsualizarTicket(context, item);
        },
      ));
    }
    return listaTickets;
  }

  Widget _iconoPrioridad(prioridad) {
    switch (prioridad) {
      case 'Baja':
        return CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(prioridad.substring(0, 1),
              style: const TextStyle(color: Colors.white)),
        );
        break;
      case 'Normal':
        return CircleAvatar(
          backgroundColor: Colors.amber,
          child: Text(prioridad.substring(0, 1),
              style: const TextStyle(color: Colors.white)),
        );
        break;
      case 'Alta':
        return CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text(prioridad.substring(0, 1),
              style: const TextStyle(color: Colors.white)),
        );
        break;
      case 'Urgente':
        return CircleAvatar(
          backgroundColor: Colors.red,
          child: Text(prioridad.substring(0, 1),
              style: const TextStyle(color: Colors.white)),
        );
        break;
    }
    return CircleAvatar(
      child: Text(prioridad.substring(0, 1)),
    );
  }

  Future<void> _mensajeLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Realmente desea salir de la aplicación?'),
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
                'Salir',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                mensajes.mensajeFlash(context, "Procesando la petición");
                if (await UserController().apiLogout()) {
                  mensajes.quitarMensajeFlash(context);
                  mensajes.mensajeFlash(
                      context, "La sesión se cerró con exito");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                } else {
                  mensajes.quitarMensajeFlash(context);
                  mensajes.mensajeFlash(context, "Error durante la operación");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future _previsualizarTicket(context, Ticket ticket) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Folio: ${ticket.folio}',
              style: const TextStyle(
                color: Color.fromRGBO(7, 121, 84, 1),
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
                      Text(ticket.prioridad),
                      const Text(
                        "Nombre:",
                        style: TextStyle(
                            color: Color.fromRGBO(7, 121, 84, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      Text(ticket.usuarioFinal),
                      const Text("Estatus:",
                          style: TextStyle(
                              color: Color.fromRGBO(7, 121, 84, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      Text(ticket.estatus),
                      const Text("Área:",
                          style: TextStyle(
                              color: Color.fromRGBO(7, 121, 84, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      Text(ticket.area),
                      const Text("Tipo de servicio:",
                          style: TextStyle(
                              color: Color.fromRGBO(7, 121, 84, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      Text(ticket.categoria),
                      // const Text("Síntoma:",
                      //     style: TextStyle(
                      //         color: Colors.blue,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16.0)),
                      // Text(ticket.sintoma),
                      const Text("Descripción:",
                          style: TextStyle(
                              color: Color.fromRGBO(7, 121, 84, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      Text(ticket.descripcion),
                    ],
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
                  'Abrir Ticket',
                  style: TextStyle(
                      color: Color.fromRGBO(7, 121, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowTicket(
                      ticket: ticket,
                    ),
                  ));
                },
              ),
            ],
          );
        });
  }

  Future _cambiarPassword(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Actualizar password',
              style: TextStyle(
                  color: Color.fromRGBO(7, 121, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscuringCharacter: '*',
                    obscureText: true,
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
                      labelText: 'Password actual:',
                    ),
                    onChanged: (value) {
                      currentPassword = value;
                    },
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscuringCharacter: '*',
                    obscureText: true,
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
                      labelText: 'Nuevo password:',
                    ),
                    onChanged: (value) {
                      newPassword = value;
                    },
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscuringCharacter: '*',
                    obscureText: true,
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
                      labelText: 'Confirmar password:',
                    ),
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 20,
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
                  'Actualizar',
                  style: TextStyle(
                      color: Color.fromRGBO(7, 121, 84, 1),
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (currentPassword.isEmpty ||
                      newPassword.isEmpty ||
                      confirmPassword.isEmpty) {
                    mensajes.mensajeEmergente(
                        context, "Error", "Todos los campos son obligatorios.");
                  } else {
                    if (newPassword == confirmPassword) {
                      print('$newPassword  $confirmPassword');
                      if (await UserController().apiActualizarPassword(
                          context, currentPassword, newPassword)) {
                        Navigator.pop(context);
                      }
                    } else {
                      mensajes.mensajeEmergente(context, "Error",
                          "Su nuevo password no coincide con la confirmación.");
                    }
                  }

                  // if (await TicketController().apiactualizarEstatusTicket(
                  //     context, currentTicket.id, estatusEdit)) {
                  //   currentTicket = await TicketController()
                  //       .apiGetTicket(context, widget.ticket.id);
                  //   llenasSeguimientos(currentTicket.seguimientos);
                  //   _listaArchivosAdjuntos(currentTicket.archivos);
                  //   Navigator.pop(context);
                  // } else {
                  //   print("Fail");
                  // }
                },
              ),
            ],
          );
        });
  }
}
