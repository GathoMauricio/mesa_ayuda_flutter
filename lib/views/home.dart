import 'package:flutter/material.dart';
import 'package:mesa_ayuda/controllers/home_controller.dart';
import 'package:mesa_ayuda/controllers/user_controller.dart';
import 'package:mesa_ayuda/models/ticket.dart';
import 'package:mesa_ayuda/views/auth/login.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;
import 'package:mesa_ayuda/views/tickets/show_ticket.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late Future<List<Ticket>> _listadoTickets;
  @override
  Widget build(BuildContext context) {
    HomeController homeController = HomeController();
    _listadoTickets = homeController.apiHome();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
          //TODO:Ir a ventana de crear ticket
          mensajes.mensajeEmergente(
              context, "To Do:", "Ir a ventana de crear ticket");
          mensajes.mensajeFlash(context, "To Do: Ir a ventana de crear ticket");
        },
        label: const Text(
          'Iniciar Ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Tickets",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _mensajeLogout();
            },
            child: const Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () async {
          mensajes.mensajeFlash(context, "Actualizando información.");
          setState(() {
            _listadoTickets = homeController.apiHome();
            mensajes.quitarMensajeFlash(context);
            mensajes.mensajeFlash(context, "Información actualizada.");
          });
        },
        child: FutureBuilder(
          future: _listadoTickets,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _listarTickets(snapshot.data as List<Ticket>),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Hay error");
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  List<Widget> _listarTickets(List<Ticket> data) {
    List<Widget> listaTickets = [];
    for (var item in data) {
      listaTickets.add(ListTile(
        title: Text(item.usuarioFinal),
        subtitle: Text("Area:" + item.area + "\n" + item.sintoma),
        leading: _iconoPrioridad(item.prioridad),
        trailing: Icon(Icons.arrow_forward_ios),
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
            title: Text('Folio: ${ticket.folio}'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  Column(
                    children: [
                      const Text(
                        "Prioridad:",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      Text(ticket.prioridad),
                      const Text(
                        "Nombre:",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      Text(ticket.usuarioFinal),
                      const Text("Estatus:",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      Text(ticket.estatus),
                      const Text("Área:",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      Text(ticket.area),
                      const Text("Categoría:",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      Text(ticket.categoria),
                      const Text("Síntoma:",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      Text(ticket.sintoma),
                      const Text("Descripción:",
                          style: TextStyle(
                              color: Colors.blue,
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
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                onPressed: () {
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
}
