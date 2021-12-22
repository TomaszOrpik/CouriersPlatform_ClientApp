import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client_app/models/courier.dart';
import 'package:client_app/models/package.dart';
import 'package:client_app/models/packageCourier.dart';
import 'package:client_app/models/position.dart';
import 'package:client_app/models/user.dart';
import '../constants.dart';

class PackagesResponse {
  List<PackageCourier> packages;

  PackagesResponse(this.packages);

  factory PackagesResponse.fromJson(List<dynamic> responseBody) {
    List<PackageCourier> packages = [];
    for (var data in responseBody) {
      final Map<String, dynamic> package = data['package'];
      final Map<String, dynamic> packageSender = package['sender'];
      final Map<String, dynamic> packageReceiver = package['receiver'];
      final Map<String, dynamic> packagePosition = package['position'];
      final Map<String, dynamic>? courier = data['courier'];
      final Map<String, dynamic>? courierPosition = courier?['startPosition'];

      final packageCourier = PackageCourier(
        package: Package(
          id: package['id'],
          packageNumber: package['packageNumber'],
          sendDate: package['sendDate'],
          receiver: User(
            id: packageReceiver['id'],
            firstName: packageReceiver['firstName'],
            lastName: packageReceiver['lastName'],
            street: packageReceiver['street'],
            postCode: packageReceiver['postCode'],
            city: packageReceiver['city'],
            phoneNumber: packageReceiver['phoneNumber'],
          ),
          sender: User(
            id: packageSender['id'],
            firstName: packageSender['firstName'],
            lastName: packageSender['lastName'],
            street: packageSender['street'],
            postCode: packageSender['postCode'],
            city: packageSender['city'],
            phoneNumber: packageSender['phoneNumber'],
          ),
          position: Position(
            latitude: packagePosition['latitude'],
            longitude: packagePosition['longitude'],
          ),
          comments: package['comments'] ?? '',
          status: package['status'],
        ),
        courier: data['courier'] != null
            ? Courier(
                employeeNumber: courier?['employeeNumber'],
                firstName: courier?['firstName'],
                lastName: courier?['lastName'],
                phoneNumber: courier?['phoneNumber'],
                startPosition: Position(
                  latitude: courierPosition?['latitude'],
                  longitude: courierPosition?['longitude'],
                ),
                vehicle: courier?['vehicle'],
                registration: courier?['registration'],
                startTime: courier?['startTime'],
              )
            : null,
        deliveryTime: data['deliveryTime'],
      );
      packages.add(packageCourier);
    }
    return PackagesResponse(packages);
  }
}

class Packages with ChangeNotifier {
  List<PackageCourier> _sendPackages = [];
  List<PackageCourier> _receivedPackages = [];

  List<PackageCourier> get sendPackages {
    return _sendPackages;
  }

  List<PackageCourier> get receivedPackages {
    return _receivedPackages;
  }

  Future<Map<String, String>> get headers async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": token ?? '',
    };
  }

  Future<void> getSendPackages(String userId, String filterValue) async {
    final headers = await this.headers;
    final url = Uri.parse('${CONSTANTS.apiEndpoint}packages/sender/$userId');
    final response = await http.get(url, headers: headers);
    final List<dynamic> responseBody = json.decode(response.body);
    final packages = PackagesResponse.fromJson(responseBody).packages;
    if (filterValue == '') {
      _sendPackages = packages;
    } else {
      _sendPackages = packages
          .where(
            (PackageCourier element) =>
                element.package.packageNumber.contains(filterValue),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> getReceivePackages(String userId, String filterValue) async {
    final headers = await this.headers;
    final url = Uri.parse('${CONSTANTS.apiEndpoint}packages/receiver/$userId');
    final response = await http.get(url, headers: headers);
    final List<dynamic> responseBody = json.decode(response.body);
    final packages = PackagesResponse.fromJson(responseBody).packages;
    if (filterValue == '') {
      _receivedPackages = packages;
    } else {
      _receivedPackages = packages
          .where(
            (PackageCourier element) =>
                element.package.packageNumber.contains(filterValue),
          )
          .toList();
    }
    notifyListeners();
  }
}
