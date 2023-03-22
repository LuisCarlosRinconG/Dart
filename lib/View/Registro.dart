import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../DTO/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../DTO/User.dart';

class Registro extends StatefulWidget{
  final User cadena;
  Registro(this.cadena);
  @override
  RegistroApp createState() => RegistroApp();
}

class RegistroApp extends State<Registro>{
  TextEditingController nombre = TextEditingController();
  TextEditingController identidad = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController contrasena = TextEditingController();

  final firebase= FirebaseFirestore.instance;

  insertarDatos() async{
    try{
      await firebase.collection("Usuarios").doc().set({
        "NombreUsuario": nombre.text,
        "IdentidadUsuario": identidad.text,
        "CorreoUsuario": correo.text,
        "Telefonousuario": telefono.text,
        "ContraseñaUsuario": contrasena.text,
        "Rol": "Invitado",
        "Estado" : true
      });
      print("Envio correcto");
      mensaje("Emergente","Registro correcto");
    }catch(e){
      print("Error en insert " + e.toString());
    }
  }
  void mensaje(String titulo, String contenido) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(contenido),
            actions: <Widget>[
              FloatingActionButton(
                onPressed: () {

                },
                child: Text('Aceptar'),
              )
            ],
          );
        });
  }


  @override
  Widget build( BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTRO DE USUARIOS --> " + widget.cadena.nombre),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10, left: 500, right: 500),
              child: TextField(
                controller: nombre,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: "Usuario"
                ),
                style: TextStyle(
                    color: Color(0xff38ac23)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10, left: 500, right: 500),
              child: TextField(
                controller: identidad,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: "Identificación"
                ),
                style: TextStyle(
                    color: Color(0xff38ac23)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10, left: 500, right: 500),
              child: TextField(
                controller: correo,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: "Correo"
                ),
                style: TextStyle(
                    color: Color(0xff38ac23)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10, left: 500, right: 500),
              child: TextField(
                controller: telefono,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: "Telefono"
                ),
                style: TextStyle(
                    color: Color(0xff38ac23)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10, left: 500, right: 500),
              child: TextField(
                controller: contrasena,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: "Contraseña"
                ),
                style: TextStyle(
                    color: Color(0xff38ac23)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20, left: 30,right: 30),
              child: ElevatedButton(
                onPressed: (){
                  insertarDatos();
                  nombre.clear();
                  identidad.clear();
                  correo.clear();
                  telefono.clear();
                  contrasena.clear();
                },
                child: Text('Registrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
