import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DTO/User.dart';
import 'View/Registro.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}
class Home extends StatefulWidget {
  @override
  HomeStart createState() => HomeStart();
}

class HomeStart extends State<Home>{
  TextEditingController nombre = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  User objUser=User();

  validarDatos() async{
    try{
      CollectionReference ref = FirebaseFirestore.instance.collection("Usuarios");
      QuerySnapshot usuario = await ref.get();

      if(usuario.docs.length !=0){
        for(var cursor in usuario.docs){
          if(cursor.get("NombreUsuario") == nombre.text){
            print("Usuario Encontrado");
            print(cursor.get("IdentidadUsuario"));
            if(cursor.get("ContraseñaUsuario") == contrasena.text){
              print("ACCESO PERMITIDO!");
              print("BIENVENIDO " + nombre.text);
              mensaje("Emergente","Acceso permitido");
              objUser.nombre=cursor.get("NombreUsuario");
              objUser.id=cursor.get("IdentidadUsuario");
              objUser.rol=("Administrador");
              //objUser.estado=
            }else{
              print("La contraseña es incorrecta");
            }
          }
        }
      }else{
        print("No hay documentos en la colección!");
      }
    }catch(e){
      print("ERROR... " + e.toString());
    }
  }

  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Bienvenidos',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Linea de Profundización II'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Container(
                  width: 300,
                  height: 300,
                  child: Image.asset('img/registro.png'),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10, left: 500, right: 500),
                child: TextField(
                  controller: nombre,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      labelText: 'Usuario',
                      hintText: 'Digite su usuario'
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30, left: 500, right: 500),
                child: TextField(
                  controller: contrasena,
                  obscureText:true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      labelText: 'Password Usuario',
                      hintText: 'Digite contraseña de usuario'
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20, left: 30,right: 30),
                child: ElevatedButton(
                  onPressed: (){
                    print('Ingresando...!');
                    validarDatos();
                  },
                  child: Text('Ingresar'),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20, left: 30,right: 30),
                child: TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Registro(objUser)));
                  },
                  child: Text('Registrar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
}