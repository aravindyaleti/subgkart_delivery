import 'dart:async';
import 'package:subgkart_delivery/data.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future _getData() async{
    await UserAuth.getUser();
    Timer(Duration(seconds: 4), (){
      if(UserAuth.user!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogIN()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/logo.png',width: 200,height: 200,)),
        ],),
    ),
    );
  }
}

