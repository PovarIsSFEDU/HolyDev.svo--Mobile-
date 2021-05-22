import 'dart:developer';

import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

import 'AdminScreen.dart';
import 'UserScreen.dart';

class EnterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String username = "";
    return new Container(
      padding: EdgeInsets.all(10.0),
      child: new Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              new Text("Имя пользователя", style: TextStyle(fontSize: 20.0)),
              new TextField(
                obscureText: false,
                onChanged: (text) {
                  username = text;
                },
                onSubmitted: (text) {
                  username = text;
                },
              ),
              new SizedBox(
                height: 20.0,
              ),
              new Text("Пароль", style: TextStyle(fontSize: 20.0)),
              new TextField(obscureText: true),
              new SizedBox(
                height: 20.0,
              ),
              new ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    http.post('http://192.168.1.42:8080/user',
                        headers: {'name': username},
                        body: {'name': username}).then((response) {
                      if (response.statusCode == 200) {
                        log(response.body);
                        switch (response.body) {
                          case "1":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserScreen()));
                            break; //TODO Это обычный пользователь
                          case "2":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminScreen()));
                            break; //TODO Это контролер
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text("Ошибка при входе!"),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }).catchError((error) {
                      print("Error: $error");
                    });
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      content: new Text("Вход произведен!"),
                      backgroundColor: Colors.green, duration: Duration(seconds: 1),
                    ));
                  }
                },
                child: Text("Войти"),
              )
            ],
          )),
    );
  }
}

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          appBar: new AppBar(title: new Text('HolyDev')), body: EnterForm())));
}
