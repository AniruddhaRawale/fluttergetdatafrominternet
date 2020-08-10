import 'dart:async';
import 'dart:io';

import 'package:fetchdatainternet/imageui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fetch Data From Internet",
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StreamSubscription _streamSubscription;
  ConnectivityResult previous;


  @override
void initState(){
  super.initState();
  try{
    //check for this url and if you get result then we are 
    //procedding
    InternetAddress.lookup("google.com").then((result){
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>
        imageui(),
         ));

      }
      else{
         _showdialog();

      }//no connection
    }).catchError((error){
       _showdialog();

    });//no connection
  }on SocketException catch(_){
//no internet
    _showdialog();
  }

  Connectivity().onConnectivityChanged.listen((ConnectivityResult connresult){
    if(connresult == ConnectivityResult.none){
      //we dont have internet from start

    }else if (previous == ConnectivityResult.none)
      {
        //internet is available now at this moment
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => imageui(),
        ));
      }

    previous ==connresult;
  });

  }

  //used to dispose stream susbscription to avoid memory leaks
  @override
  void dispose(){
    super.dispose();

    _streamSubscription.cancel();
  }

void _showdialog(){
  showDialog(
    context: context,
    builder: (context)=> AlertDialog(
      title:Text("ERROR"),
      content:Text("NO INTERNET DETECTED"),
      actions:<Widget>[
        FlatButton(
          onPressed: () => SystemChannels.platform.invokeMethod("Systemnavigator.pop"),
          child: Text("Exit"),

        )
      ]
    )
  
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Data",
        style:TextStyle(
          fontFamily: "Times New Roman",
          fontSize: 25.0
          )
        ),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(padding: EdgeInsets.only(top:20.0),),
             Padding(
               padding: const EdgeInsets.all(40.0),
               child: Text("Checking Your Internet Connection",
            style: TextStyle(
                 fontFamily: "Times New Roman",
                  fontSize: 25.0
            ),
            ),
             ),
          ],)
      ),
    );
  }
}