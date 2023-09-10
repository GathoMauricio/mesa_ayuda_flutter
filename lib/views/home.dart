import 'package:flutter/material.dart';
import 'package:mesa_ayuda/controllers/home_controller.dart';
import 'package:mesa_ayuda/controllers/user_controller.dart';
import 'package:mesa_ayuda/models/ticket.dart';
import 'package:mesa_ayuda/views/auth/login.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;

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
        onPressed: () {
          //TODO:Ir a ventana de crear ticket
          mensajes.mensajeEmergente(
              context, "To Do:", "Ir a ventana de crear ticket");
          mensajes.mensajeFlash(context, "To Do: Ir a ventana de crear ticket");
        },
        label: const Text(
          'Iniciar Ticket',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
              )),
        ],
      ),
      body: FutureBuilder(
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
    );
  }

  List<Widget> _listarTickets(List<Ticket> data) {
    List<Widget> listaTickets = [];
    for (var item in data) {
      listaTickets.add(ListTile(
        title: Text(item.usuarioFinal),
        subtitle: Text("Area:" + item.area + "\n" + item.sintoma),
        leading: CircleAvatar(
          child: Text(item.prioridad.substring(0, 1)),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          mensajes.mensajeFlash(context,
              "ToDo: Redirigir a la pantalle de Mostrar Ticket Completo");
        },
        onLongPress: () {
          _previsualizarTicket(context, item);
        },
      ));
    }
    return listaTickets;
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Procesando la petición")),
                );
                if (await UserController().apiLogout()) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("La sesión se cerró con exito")),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                } else {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error durante la operación")),
                  );
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
            title: Text('Folio: F-000045'),
            content: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
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
                  Navigator.of(context).pop();
                  mensajes.mensajeFlash(context,
                      "ToDo: Redirigir a la pantalle de Mostrar Ticket Completo");
                  //TODO: Redirigir a la pantalle de Mostrar Ticket Completo
                },
              ),
            ],
          );
        });
  }
}
