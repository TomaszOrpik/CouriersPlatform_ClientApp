import 'package:client_app/models/packageWidgetType.enum.dart';
import 'package:client_app/providers/functionality.dart';
import 'package:client_app/providers/packages.dart';
import 'package:client_app/widgets/appDrawer.dart';
import 'package:client_app/widgets/noData.dart';
import 'package:client_app/widgets/package.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivingScreen extends StatefulWidget {
  const ReceivingScreen({Key? key}) : super(key: key);

  @override
  ReceivingScreenState createState() => ReceivingScreenState();
}

class ReceivingScreenState extends State<ReceivingScreen> {
  late Future _receivingFuture;
  late String _userId;
  final _searchController = TextEditingController();

  Future _obtainReceivingFuture(String userId, String filterValue) {
    return Provider.of<Packages>(context, listen: false)
        .getReceivePackages(userId, filterValue);
  }

  String _obtainUserId() {
    return Provider.of<Functionality>(context, listen: false).userId;
  }

  @override
  void initState() {
    _userId = _obtainUserId();
    _receivingFuture = _obtainReceivingFuture(_userId, '');
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
            'PRZYCHODZĄCE',
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
                _receivingFuture = _obtainReceivingFuture(_userId, text);
              });
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 180,
          child: FutureBuilder(
            future: _receivingFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  return const Center(child: Text('Error Occured'));
                } else {
                  return Consumer<Packages>(
                    builder: (ctx, packagesData, child) =>
                        packagesData.receivedPackages.isEmpty
                            ? const NoData(
                                'Brak Danych do Wyświetlenia',
                                'Nie odnotowaliśmy żadnych przesyłek na twoim koncie',
                                Icons.gps_off,
                              )
                            : ListView.builder(
                                itemCount: packagesData.receivedPackages.length,
                                itemBuilder: (ctx, i) => PackageWidget(
                                  packagesData.receivedPackages[i],
                                  PackageWidgetType.sender,
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
