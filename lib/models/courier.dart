import 'package:client_app/models/position.dart';

class Courier {
  String employeeNumber;
  String firstName;
  String lastName;
  num phoneNumber;
  Position startPosition;
  String vehicle;
  String registration;
  String startTime;

  Courier({
    required this.employeeNumber,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.startPosition,
    required this.vehicle,
    required this.registration,
    required this.startTime,
  });
}
