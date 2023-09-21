import 'package:flutter/material.dart';
import 'package:mesa_ayuda/controllers/TicketController.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../controllers/SeguimientoController.dart';
import '../../models/Seguimiento.dart';
import '../../models/Ticket.dart';

class ShowTicket extends StatefulWidget {
  Ticket ticket;
  ShowTicket({super.key, required this.ticket});

  @override
  State<ShowTicket> createState() => _ShowTicketState();
}

class _ShowTicketState extends State<ShowTicket> {
  List<ListTile> _segimientos = [];
  String textoSeguimiento = "";
  Ticket currentTicket = Ticket(0, 'estatus', 'area', 'categoria', 'sintoma',
      'usuarioFinal', 'folio', 'prioridad', 'descripcion');
  @override
  void initState() {
    super.initState();
    currentTicket = widget.ticket;
    llenasSeguimientos(currentTicket.seguimientos);
  }

  void llenasSeguimientos(seguimientos) {
    _segimientos = [];
    for (var seguimiento in seguimientos) {
      setState(() {
        _segimientos.add(
          ListTile(
            title: Text(seguimiento.autor,
                style:
                    const TextStyle(color: Colors.blueAccent, fontSize: 14.0)),
            subtitle: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(seguimiento.texto),
                Text(
                  seguimiento.createdAt,
                  style: TextStyle(fontSize: 12.0),
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
        backgroundColor: Colors.blue,
        title: Text(
          "Folio: ${widget.ticket.folio}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SlidingUpPanel(
        minHeight: 80,
        maxHeight: MediaQuery.of(context).size.height * 0.4,
        color: Colors.transparent,
        body: ticketBody(),
        panel: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0), color: Colors.white),
          child: Column(children: [
            Icon(Icons.drag_handle_rounded),
            Text(
              "Agregar seguimiento",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enviar seguimiento'),
              onChanged: (value) {
                textoSeguimiento = value;
              },
              maxLines: 2,
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Guardar"), Icon(Icons.send)],
                ))
          ]),
        ),
      ),
    );
  }

  Widget ticketBody() {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.blue,
      strokeWidth: 4.0,
      onRefresh: () async {
        mensajes.mensajeFlash(context, "Actualizando información.");
        currentTicket =
            await TicketController().apiGetTicket(context, widget.ticket.id);
        llenasSeguimientos(currentTicket.seguimientos);
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
                Text(currentTicket.prioridad),
                const Text(
                  "Nombre:",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                Text(currentTicket.usuarioFinal),
                const Text("Estatus:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.estatus),
                const Text("Área:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.area),
                const Text("Categoría:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.categoria),
                const Text("Síntoma:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.sintoma),
                const Text("Descripción:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(currentTicket.descripcion),
                const SizedBox(
                  height: 20.0,
                ),
                // const Text("Documentos Adjuntos",
                //     style: TextStyle(
                //         color: Colors.purple, fontWeight: FontWeight.bold)),
                // Column(children: [
                //   ListTile(
                //     title: const Text("Título del documento",
                //         style: TextStyle(color: Colors.lightBlueAccent)),
                //     subtitle: const Column(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Text("Descripción del documento."),
                //       ],
                //     ),
                //     leading: Icon(Icons.file_open),
                //     trailing: Icon(Icons.attach_file),
                //     onTap: () {},
                //     onLongPress: () {},
                //   ),
                // ]),
                // const SizedBox(
                //   height: 20.0,
                // ),
                const Text("Seguimientos",
                    style: TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold)),
                Column(
                  children: _segimientos.length > 0
                      ? _segimientos +
                          [
                            ListTile(),
                            ListTile(),
                            ListTile(),
                          ]
                      : [Text("No se han agregado seguimientos")],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
