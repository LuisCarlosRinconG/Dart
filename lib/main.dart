import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'DTO/User.dart';
import 'View/Registro.dart';
import 'firebase_options.dart';
import 'package:local_auth/local_auth.dart';

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
  final LocalAuthentication auth=LocalAuthentication();
  User objUser=User();
  int IyA=0;
  String n="";

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
              objUser.nombre=cursor.get("NombreUsuario");
              objUser.id=cursor.get("IdentidadUsuario");
              objUser.rol= cursor.get("Rol");
              objUser.estado=cursor.get("Estado");
              n=nombre.text;

              if(cursor.get("Rol")=="Invitado"){
                mensaje("Invitado","Bienvenido usuario invitado: "+n);
                IyA=1;

              }else if(cursor.get("Rol")=="Admin"){
                mensaje("Admin","Bienvenido usuario administrador: "+n);
                IyA=2;
              }

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
              ),
              Padding(padding: EdgeInsets.only(top:20, left: 30, right: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(50,50),
                  backgroundColor:Colors.black45,
                ),
                onPressed: () async {
                  if(await biometrico())
                  mensaje("Huella","Huella encontrada");
                },
                  child: Icon(Icons.fingerprint, size:80)
              ),
              ),
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
                if(IyA==1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => invitado()),
                  );
                }else if(IyA==2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => admin()),
                  );
                }

                },
                child: Text('Aceptar'),
              )
            ],
          );
        });
  }
  Future<bool> biometrico() async {
    //print("biométrico");

    // bool flag = true;
    bool authenticated = false;

    const androidString = const AndroidAuthMessages(
      cancelButton: "Cancelar",
      goToSettingsButton: "Ajustes",
      signInTitle: "Ingrese",
      //fingerprintNotRecognized: 'Error de reconocimiento de huella digital',
      goToSettingsDescription: "Confirme su huella",
      //fingerprintSuccess: 'Reconocimiento de huella digital exitoso',
      biometricHint: "Toque el sensor",
      //signInTitle: 'Verificación de huellas digitales',
      biometricNotRecognized: "Huella no reconocida",
      biometricRequiredTitle: "Required Title",
      biometricSuccess: "Huella reconocida",
      //fingerprintRequiredTitle: '¡Ingrese primero la huella digital!',
    );
    bool canCheckBiometrics = await auth.canCheckBiometrics;// verifica que el lector boimetrico se puede utilizar
    // bool isBiometricSupported = await auth.();
    bool isBiometricSupported = await auth.isDeviceSupported();

    List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();
    print(canCheckBiometrics); //Returns trueB
    // print("support -->" + isBiometricSupported.toString());
    print(availableBiometrics.toString()); //Returns [BiometricType.fingerprint]
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Autentíquese para acceder",
          useErrorDialogs: true,
          stickyAuth: true,
          //biometricOnly: true,
          androidAuthStrings: androidString);
      if (!authenticated) {
        authenticated = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    /* if (!mounted) {
        return;
      }*/

    return authenticated;
  }
}
//Apartado para la creacion de las clases invitado y Admin
class invitado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitado'),
        backgroundColor: Colors.amberAccent,

      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Hasta pronto'),
        ),
      ),
    );
  }
}

class admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Hasta pronto'),
        ),
      ),
    );
  }
}