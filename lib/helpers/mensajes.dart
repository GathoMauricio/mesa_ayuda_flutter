import 'package:flutter/material.dart';
import 'package:mesa_ayuda/views/descargar_version.dart';

Future<void> mensajeEmergente(context, String titulo, String texto) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(texto),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void mensajeFlash(context, String texto) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  } catch (e) {
    print(e);
  }
}

Future mensajeTest(context) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Folio: F-000045'),
          content: Container(
            height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            child: const Column(
              children: [
                Text(
                  "Nombre:",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                Text("Jack Nightmare skellington"),
                Text("Estatus:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text("Esdsfdfg"),
                Text("'Area':",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text("Afg tert"),
                Text("Categoría:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text("Catdsfsd ffsdf"),
                Text("Síntoma:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text("Swerre fsefdlretano"),
                Text("Descripción:",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(
                    "Degfhjdskj wflre sdofhg g   fdg df g d fg ijorit ohg  ouh gosdfhg sdofhg odsfhg   fdg df g d fg ijorit ohg  ouh gosdfhg sdofhg odsfhg ohfgosdfhgshdfgljkhsdhfksdfgkjsfdgkjdsfgkjhdfsgkjds rcer v yturec tr tvr ty tb  g56."),
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
              },
            ),
          ],
        );
      });
}

void quitarMensajeFlash(context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}

Future<void> mensajeNuevaVersion(
    context, String titulo, String texto, String nuevaVersion) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:
            Text(titulo, style: TextStyle(color: Colors.green, fontSize: 18.0)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(texto),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Descargar ahora',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          DescargarVersion(nuevaVersion: nuevaVersion)),
                  (route) => false);
            },
          ),
        ],
      );
    },
  );
}
