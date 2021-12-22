// ignore_for_file: file_names

import 'package:client_app/providers/functionality.dart';
import 'package:client_app/screens/help.screen.dart';
import 'package:client_app/screens/registrations.screen.dart';
import 'package:client_app/screens/sending.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userId = Provider.of<Functionality>(context).userId;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => {
                      Navigator.of(context).pop(),
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 50,
                    ),
                    alignment: Alignment.centerLeft,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    userId,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.my_location,
                      color: ModalRoute.of(context)?.settings.name == '/'
                          ? Colors.blue
                          : Colors.black,
                    ),
                    title: Text(
                      'Przychodzące Przesyłki',
                      style: TextStyle(
                          color: ModalRoute.of(context)?.settings.name == '/'
                              ? Colors.blue
                              : Colors.black),
                    ),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed('/');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_searching,
                      color: ModalRoute.of(context)?.settings.name ==
                              SendingScreen.name
                          ? Colors.blue
                          : Colors.black,
                    ),
                    title: Text(
                      'Wychodzące Przesyłki',
                      style: TextStyle(
                          color: ModalRoute.of(context)?.settings.name ==
                                  SendingScreen.name
                              ? Colors.blue
                              : Colors.black),
                    ),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(SendingScreen.name);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: ModalRoute.of(context)?.settings.name ==
                              RegistrationsScreen.name
                          ? Colors.blue
                          : Colors.black,
                    ),
                    title: Text(
                      'Zgłoszenia',
                      style: TextStyle(
                          color: ModalRoute.of(context)?.settings.name ==
                                  RegistrationsScreen.name
                              ? Colors.blue
                              : Colors.black),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(RegistrationsScreen.name);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.help,
                      color: ModalRoute.of(context)?.settings.name ==
                              HelpScreen.name
                          ? Colors.blue
                          : Colors.black,
                    ),
                    title: Text(
                      'Pomoc',
                      style: TextStyle(
                          color: ModalRoute.of(context)?.settings.name ==
                                  HelpScreen.name
                              ? Colors.blue
                              : Colors.black),
                    ),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(HelpScreen.name);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    title: const Text('Wyloguj Się'),
                    onTap: () {
                      Provider.of<Functionality>(context, listen: false)
                          .logOut();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.48,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: [
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: const Text(
                              'Informacje Prawne',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () => {},
                          ),
                          const Text('Ver 1.0'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
