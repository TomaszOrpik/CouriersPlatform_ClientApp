import 'package:client_app/providers/functionality.dart';
import 'package:client_app/providers/registrations.dart';
import 'package:client_app/widgets/appDrawer.dart';
import 'package:client_app/widgets/noData.dart';
import 'package:client_app/widgets/registration.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationsScreen extends StatefulWidget {
  static const name = '/notifications';

  const RegistrationsScreen({Key? key}) : super(key: key);

  @override
  RegistrationsScreenState createState() => RegistrationsScreenState();
}

class RegistrationsScreenState extends State<RegistrationsScreen> {
  late Future _registrationsFuture;
  late String _userId;
  final _searchController = TextEditingController();

  Future _obtainRegistrationsFuture(String userId, String filterValue) {
    return Provider.of<Registrations>(context, listen: false)
        .getRegistrations(userId, filterValue);
  }

  String _obtainUserId() {
    return Provider.of<Functionality>(context, listen: false).userId;
  }

  @override
  void initState() {
    _userId = _obtainUserId();
    _registrationsFuture = _obtainRegistrationsFuture(_userId, '');
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.only(left: 30, top: 10),
          child: Text(
            'ZGŁOSZENIA',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                size: 40,
                color: Colors.blue,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        shadowColor: null,
      ),
      body: Column(children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: TextField(
            enableSuggestions: true,
            autocorrect: true,
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Numer Zgłoszenia',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 0.5),
              ),
            ),
            onChanged: (text) {
              setState(() {
                _registrationsFuture =
                    _obtainRegistrationsFuture(_userId, text);
              });
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 180,
          child: FutureBuilder(
            future: _registrationsFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  return const Center(child: Text('Error Occured'));
                } else {
                  return Consumer<Registrations>(
                    builder: (ctx, registrationData, child) => registrationData
                            .registrations.isEmpty
                        ? const NoData(
                            'Brak Zgłoszeń',
                            'Nie odnotowaliśmy żadnych zgłoszeń na twoim koncie',
                            Icons.notifications_off,
                          )
                        : ListView.builder(
                            itemCount: registrationData.registrations.length,
                            itemBuilder: (ctx, i) => RegistrationWidget(
                                registrationData.registrations[i]),
                          ),
                  );
                }
              }
            },
          ),
        ),
      ]),
    );
  }
}
