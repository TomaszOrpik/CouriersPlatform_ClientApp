import 'package:client_app/models/package.dart';
import 'package:client_app/models/user.dart';

class Registration {
  final String id;
  final Package package;
  final String date;
  final User user;
  final String subject;
  final String additionaInfo;
  final int contactPhone;
  final String contactMail;
  final String status;

  Registration(
      {required this.id,
      required this.package,
      required this.date,
      required this.user,
      required this.subject,
      required this.additionaInfo,
      required this.contactMail,
      required this.contactPhone,
      required this.status});
}
