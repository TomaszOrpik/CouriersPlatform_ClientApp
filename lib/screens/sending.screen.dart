import 'package:client_app/models/packageWidgetType.enum.dart';
import 'package:client_app/providers/functionality.dart';
import 'package:client_app/providers/packages.dart';
import 'package:client_app/widgets/appDrawer.dart';
import 'package:client_app/widgets/noData.dart';
import 'package:client_app/widgets/package.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendingScreen extends StatefulWidget {
  static const name = '/sending';

  const SendingScreen({Key? key}) : super(key: key);

  @override
  SendingScreenState createState() => SendingScreenState();
}

class SendingScreenState extends State<SendingScreen> {
  late Future _sendingFuture;
  late String _userId;
  final _searchController = TextEditingController();

  Future _obtainSendingFuture(String userId, String filterValue) {
    return Provider.of<Packages>(context, listen: false)
        .getSendPackages(userId, filterValue);
  }

  String _obtainUserId() {
    return Provider.of<Functionality>(context, listen: false).userId;
  }

  @override
  void initState() {
    _userId = _obtainUserId();
    _sendingFuture = _obtainSendingFuture(_userId, '');
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
            'WYCHODZĄCE',
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
              labelText: 'Numer Przesyłki',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 0.5),
              ),
            ),
            onChanged: (text) {
              setState(() {
                _sendingFuture = _obtainSendingFuture(_userId, text);
              });
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 180,
          child: FutureBuilder(
            future: _sendingFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  return const Center(child: Text('Error Occured'));
                } else {
                  return Consumer<Packages>(
                    builder: (ctx, packagesData, child) =>
                        packagesData.sendPackages.isEmpty
                            ? const NoData(
                                'Brak Danych do Wyświetlenia',
                                'Nie odnotowaliśmy żadnych przesyłek na twoim koncie',
                                Icons.gps_off,
                              )
                            : ListView.builder(
                                itemCount: packagesData.sendPackages.length,
                                itemBuilder: (ctx, i) => PackageWidget(
                                  packagesData.sendPackages[i],
                                  PackageWidgetType.receiver,
                                ),
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
