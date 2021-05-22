class Order {
  int order_id;
  double lat;
  double lng;
  int order_type;
  String workers_id;
  String date;
  int status;
  int checker_id;

  Order(
      {required this.order_id,
      required this.lat,
      required this.lng,
      required this.order_type,
      required this.workers_id,
      required this.date,
      required this.status,
      required this.checker_id});

  factory Order.okOrder() {
    return Order(
        order_id: -1,
        lat: 0.0,
        lng: 0.0,
        order_type: -1,
        workers_id: "",
        date: "",
        status: -1,
        checker_id: -1);
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      order_id: json['order_id'] as int,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
      order_type: json['order_type'] as int,
      workers_id: json['workers_id'] as String,
      date: json['date'] as String,
      status: json['status'] as int,
      checker_id: json['checker_id'] as int,
    );
  }
}
