//Todo Экран обычного работяги
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Контролёр"),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Назад'))),
    );
  }
}
