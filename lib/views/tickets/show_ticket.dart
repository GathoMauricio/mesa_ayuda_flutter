import 'package:flutter/material.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;

import '../../models/ticket.dart';

class ShowTicket extends StatefulWidget {
  Ticket ticket;
  ShowTicket({super.key, required this.ticket});

  @override
  State<ShowTicket> createState() => _ShowTicketState();
}

class _ShowTicketState extends State<ShowTicket> {
  late Ticket ticket;
  @override
  void initState() {
    print(widget.ticket.folio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
          //TODO:Ir a ventana de agregar seguimiento
          mensajes.mensajeEmergente(
              context, "To Do:", "Ir a ventana de agregar seguimiento");
          mensajes.mensajeFlash(context, "Ir a ventana de agregar seguimiento");
        },
        label: const Text(
          'Seguimiento',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(
          Icons.chat_bubble,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Folio: ${widget.ticket.folio}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () async {
          mensajes.mensajeFlash(context, "Actualizando información.");
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
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
                  Text(widget.ticket.prioridad),
                  const Text(
                    "Nombre:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  Text(widget.ticket.usuarioFinal),
                  const Text("Estatus:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Text(widget.ticket.estatus),
                  const Text("Área:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Text(widget.ticket.area),
                  const Text("Categoría:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Text(widget.ticket.categoria),
                  const Text("Síntoma:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Text(widget.ticket.sintoma),
                  const Text("Descripción:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Text(widget.ticket.descripcion),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Documentos Adjuntos",
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold)),
                  Column(children: [
                    ListTile(
                      title: const Text("Título del documento",
                          style: TextStyle(color: Colors.lightBlueAccent)),
                      // subtitle: const Column(
                      //   mainAxisSize: MainAxisSize.max,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text("Título del documento."),
                      //   ],
                      // ),
                      leading: Icon(Icons.file_open),
                      trailing: Icon(Icons.attach_file),
                      onTap: () {},
                      onLongPress: () {},
                    ),
                  ]),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Seguimientos",
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold)),
                  Column(
                    children: [
                      ListTile(
                        title: const Text("Jack Skellington Flutter",
                            style: TextStyle(color: Colors.blueAccent)),
                        subtitle: const Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Contenido del seguimiento..."),
                            Text(
                              "00/00/0000 00:00",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                        leading: const Icon(Icons.person),
                        trailing: const Icon(Icons.chat_bubble),
                        onTap: () {},
                        onLongPress: () {},
                      ),
                      ListTile(
                        title: const Text("Jack Skellington Flutter",
                            style: TextStyle(color: Colors.blueAccent)),
                        subtitle: const Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Contenido del seguimiento..."),
                            Text(
                              "00/00/0000 00:00",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                        leading: Icon(Icons.person),
                        trailing: Icon(Icons.chat_bubble),
                        onTap: () {},
                        onLongPress: () {},
                      ),
                      ListTile(
                        title: const Text("Jack Skellington Flutter",
                            style: TextStyle(color: Colors.blueAccent)),
                        subtitle: const Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Contenido del seguimiento..."),
                            Text(
                              "00/00/0000 00:00",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                        leading: Icon(Icons.person),
                        trailing: Icon(Icons.chat_bubble),
                        onTap: () {},
                        onLongPress: () {},
                      ),
                      ListTile(
                        title: const Text("Jack Skellington Flutter",
                            style: TextStyle(color: Colors.blueAccent)),
                        subtitle: const Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Contenido del seguimiento..."),
                            Text(
                              "00/00/0000 00:00",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                        leading: Icon(Icons.person),
                        trailing: Icon(Icons.chat_bubble),
                        onTap: () {},
                        onLongPress: () {},
                      ),
                      ListTile(
                        title: const Text("Jack Skellington Flutter",
                            style: TextStyle(color: Colors.blueAccent)),
                        subtitle: const Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Contenido del seguimiento..."),
                            Text(
                              "00/00/0000 00:00",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                        leading: Icon(Icons.person),
                        trailing: Icon(Icons.chat_bubble),
                        onTap: () {},
                        onLongPress: () {},
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
