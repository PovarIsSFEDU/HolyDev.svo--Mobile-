//ToDo Экран работы с админкой
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Order.dart';
import 'main.dart';

class AdminScreen extends StatefulWidget {
  int _id = 0;

  AdminScreen(int id) {
    _id = id;
  }

  @override
  State<StatefulWidget> createState() {
    return _UserScreenState(_id);
  }
}

class _UserScreenState extends State<AdminScreen> {
  int _id = 0;
  Order _currentOrder = Order.okOrder();
  Order _testOrder = Order.okOrder();

  _UserScreenState(int id) {
    _id = id;
    setTimer();
  }

  void setTimer() {
    print("Запрос отправлен");
    Future.delayed(const Duration(seconds: 5), () async {
      final order = await fetchOrder(_id);
      print(order.order_id);
      _currentOrder = order;
      if (_currentOrder.status == 3) _currentOrder = _testOrder;
      setTimer();
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final widget = _currentOrder.order_id == _testOrder.order_id
        ? Text(
            "Нет заказов",
            style: TextStyle(fontSize: 16),
          )
        : getWidget(_currentOrder);
    return Scaffold(
        appBar: AppBar(
          title: Text("Проверяющий"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(children: [
            InteractiveViewer(
              child: Image.asset("image/map.png"),
              scaleEnabled: true,
            ),
            new Container(child: widget)
          ]),
        ));
  }

  Widget getWidget(Order o) {
    String order = "";
    switch (o.order_type) {
      case 1:
        order = "подметание";
        break;
      case 2:
        order = "Обработка реагентом";
        break;
      case 3:
        order = "формирование валов";
        break;
      case 4:
        order = "перемещение снега";
        break;
      case 5:
        order = "погрузка снега";
        break;
      case 6:
        order = "вывоз снега";
        break;
      case 7:
        order = "очистка мест размещеия";
        break;
      default:
        order = "неизвестный заказ";
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "id: " + o.order_id.toString(),
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "широта: " + o.lat.toString(),
              style: TextStyle(fontSize: 25),
            ),
            Text(
              "долгота: " + o.lng.toString(),
              style: TextStyle(fontSize: 25),
            ),
            Text(
              "проверяющий: Вы", //+ o.checker_id.toString(),
              style: TextStyle(fontSize: 25),
            ),
            Text(
              "заказ: " + order,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            FlatButton(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "подтвердить выполнения",
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              onPressed: _onPressed,
              textColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blueAccent),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _onPressed() async {
    Widget okButton = FlatButton(
      child: Text("да"),
      onPressed: (){
        _sendConfirm();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Подтвердить задание?"),
      actions: [
        okButton,
        FlatButton(
          child: Text("нет"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
      barrierDismissible: false,
    );
  }

  void _sendConfirm() async {
    final response = await http.post('http://' + ip + ':8080/upd',
        headers: {"orderId": _currentOrder.order_id.toString()});
  }

  Order parseOrder(String responseBody) {
    final parsed = Map<String, dynamic>.from(jsonDecode(responseBody));

    return Order.fromJson(parsed);
  }

  Future<Order> fetchOrder(int id) async {
    final response = await http
        .get(Uri.parse('http://' + ip + ':8080/kontr?id=' + id.toString()));
    return parseOrder(response.body);
  }
}
