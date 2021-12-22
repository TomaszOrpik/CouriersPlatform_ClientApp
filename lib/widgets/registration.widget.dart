import 'package:client_app/models/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class RegistrationWidget extends StatefulWidget {
  final Registration registration;

  const RegistrationWidget(this.registration, {Key? key}) : super(key: key);

  @override
  RegistrationWidgetState createState() => RegistrationWidgetState();
}

class RegistrationWidgetState extends State<RegistrationWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? 380 : 170,
      child: Card(
        margin: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'Numer Zgłoszenia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.registration.id,
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(''),
                const Text(
                  'Temat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.registration.subject,
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(''),
                _expanded
                    ? const Text(
                        'Numer Przesyłki',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox.shrink(),
                _expanded
                    ? Text(
                        widget.registration.package.id,
                        style: const TextStyle(fontSize: 14),
                      )
                    : const SizedBox.shrink(),
                _expanded ? const Text('') : const SizedBox.shrink(),
                _expanded
                    ? const Text(
                        'Telefon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox.shrink(),
                _expanded
                    ? Text(
                        widget.registration.contactPhone.toString(),
                        style: const TextStyle(fontSize: 14),
                      )
                    : const SizedBox.shrink(),
                _expanded ? const Text('') : const SizedBox.shrink(),
                _expanded
                    ? const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox.shrink(),
                _expanded
                    ? Text(
                        widget.registration.contactMail,
                        style: const TextStyle(fontSize: 14),
                      )
                    : const SizedBox.shrink(),
                _expanded ? const Text('') : const SizedBox.shrink(),
                _expanded
                    ? const Text(
                        'Dodatkowe Informacje',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox.shrink(),
                _expanded
                    ? Text(
                        widget.registration.additionaInfo,
                        style: const TextStyle(fontSize: 14),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.registration.status,
                      style: TextStyle(
                          color: widget.registration.status == 'Rozwiązane'
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  iconSize: 75,
                  icon: Icon(
                    _expanded
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//card info list: 
