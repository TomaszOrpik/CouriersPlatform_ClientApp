import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client_app/constants.dart';
import 'package:client_app/models/package.dart';
import 'package:client_app/models/position.dart';
import 'package:client_app/models/registration.dart';
import 'package:client_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationResponse {
  List<Registration> registrations;

  RegistrationResponse(this.registrations);

  factory RegistrationResponse.fromJson(List<dynamic> responseBody) {
    List<Registration> registrations = [];
    for (var data in responseBody) {
      final Map<String, dynamic> package = data['package'];
      final Map<String, dynamic> user = data['user'];
      final Map<String, dynamic> packageSender = package['sender'];
      final Map<String, dynamic> packageReceiver = package['receiver'];
      final Map<String, dynamic> packagePosition = package['position'];
      final registration = Registration(
        id: data['id'],
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
            status: package['status']),
        date: data['date'],
        user: User(
          id: user['id'],
          firstName: user['firstName'],
          lastName: user['lastName'],
          street: user['street'],
          postCode: user['postCode'],
          city: user['city'],
          phoneNumber: user['phoneNumber'],
        ),
        subject: data['subject'],
        additionaInfo: data['additionaInfo'] ?? '',
        contactMail: data['contactMail'],
        contactPhone: data['contactPhone'],
        status: data['status'],
      );
      registrations.add(registration);
    }
    return RegistrationResponse(registrations);
  }
}

class Registrations with ChangeNotifier {
  List<Registration> _registrations = [];

  List<Registration> get registrations {
    return _registrations;
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

  Future<void> getRegistrations(String userId, String filterValue) async {
    final headers = await this.headers;
    final url = Uri.parse('${CONSTANTS.apiEndpoint}registrations/user/$userId');
    final response = await http.get(url, headers: headers);
    final List<dynamic> responseBody = json.decode(response.body);
    final registrations =
        RegistrationResponse.fromJson(responseBody).registrations;
    if (filterValue == '') {
      _registrations = registrations;
    } else {
      _registrations = registrations
          .where(
            (Registration element) => element.id.contains(filterValue),
          )
          .toList();
    }
    notifyListeners();
  }
}
