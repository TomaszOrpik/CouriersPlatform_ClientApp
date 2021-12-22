// ignore_for_file: file_names

import 'package:client_app/models/courier.dart';
import 'package:client_app/models/package.dart';

class PackageCourier {
  Package package;
  Courier? courier;
  String? deliveryTime;

  PackageCourier({
    required this.package,
    this.courier,
    this.deliveryTime,
  });
}
