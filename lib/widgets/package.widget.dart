import 'package:client_app/models/packageCourier.dart';
import 'package:client_app/models/packageWidgetType.enum.dart';
import 'package:client_app/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageWidget extends StatefulWidget {
  final PackageCourier packageCourier;
  final PackageWidgetType type;

  const PackageWidget(this.packageCourier, this.type, {Key? key})
      : super(key: key);

  @override
  PackageWidgetState createState() => PackageWidgetState();
}

class PackageWidgetState extends State<PackageWidget> {
  bool _expanded = false;

  void onCallClick() {
    launch("tel://${widget.packageCourier.courier?.phoneNumber}");
  }

  void onMessageClick() {
    launch(
        'sms:${widget.packageCourier.courier?.phoneNumber}?body=Proszę%20o%20kontakt%20w%20sprawie%20przesyłki%20${widget.packageCourier.package.packageNumber}');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? 490 : 180,
      child: Card(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Nr Przesylki',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.packageCourier.package.packageNumber,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Text(''),
                    widget.type == PackageWidgetType.sender
                        ? const Text(
                            'Nadawca',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            'Odbiorca',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    widget.type == PackageWidgetType.sender
                        ? Text(
                            '${widget.packageCourier.package.sender.firstName} ${widget.packageCourier.package.sender.lastName}',
                            style: const TextStyle(fontSize: 14),
                          )
                        : Text(
                            '${widget.packageCourier.package.receiver.firstName} ${widget.packageCourier.package.receiver.lastName}',
                            style: const TextStyle(fontSize: 14),
                          ),
                    widget.type == PackageWidgetType.sender
                        ? Text(
                            widget.packageCourier.package.sender.street,
                            style: const TextStyle(fontSize: 14),
                          )
                        : Text(
                            widget.packageCourier.package.receiver.street,
                            style: const TextStyle(fontSize: 14),
                          ),
                    widget.type == PackageWidgetType.sender
                        ? Text(
                            '${widget.packageCourier.package.sender.postCode} ${widget.packageCourier.package.sender.city}',
                            style: const TextStyle(fontSize: 14),
                          )
                        : Text(
                            '${widget.packageCourier.package.receiver.postCode} ${widget.packageCourier.package.receiver.city}',
                            style: const TextStyle(fontSize: 14),
                          ),
                    widget.packageCourier.courier != null && _expanded
                        ? const Text('')
                        : const SizedBox.shrink(),
                    widget.packageCourier.courier != null && _expanded
                        ? const Text(
                            'Przewidywana Dostawa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox.shrink(),
                    widget.packageCourier.courier != null && _expanded
                        ? Text(
                            widget.packageCourier.deliveryTime ?? '',
                            style: const TextStyle(fontSize: 14),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Column(
                  children: [
                    widget.packageCourier.courier != null
                        ? IconButton(
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
                        : const SizedBox.shrink(),
                    const Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.packageCourier.package.status,
                      style: TextStyle(
                          color: widget.packageCourier.package.status ==
                                  'Niedostarczona'
                              ? Colors.red
                              : widget.packageCourier.package.status ==
                                      'Dostarczona'
                                  ? Colors.green
                                  : Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    widget.packageCourier.courier != null && _expanded
                        ? Row(children: [
                            IconButton(
                              onPressed: () => {onMessageClick()},
                              icon: const Icon(
                                Icons.message,
                                color: Colors.black,
                                size: 40,
                              ),
                            ),
                            IconButton(
                              onPressed: () => {onCallClick()},
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: 40,
                              ),
                            ),
                          ])
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
            widget.packageCourier.courier != null && _expanded
                ? MapWidget(widget.packageCourier.package.id)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
