import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Registro extends StatefulWidget{
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
      });
      print("Envio correcto");
    }catch(e){
      print("Error en insert " + e.toString());
    }
  }

  @override
  Widget build( BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTRO DE USUARIOS"),
        backgroundColor: Colors.green,
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
                    color: Color(0xff610316)
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
                    color: Color(0xff610316)
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
                    color: Color(0xff610316)
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
                    color: Color(0xff610316)
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
                    color: Color(0xff610316)
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