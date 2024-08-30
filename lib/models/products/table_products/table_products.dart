import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/associated.dart';

// ignore: must_be_immutable
class TableProducts extends StatefulWidget {
  TableProducts({required this.idOrder, super.key});

  int idOrder;

  @override
  State<TableProducts> createState() => _TableProductsState();
}

class _TableProductsState extends State<TableProducts> {
  bool loadingAccess = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: Associato().data(widget.idOrder),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Container();
            } else {
              return hasData(snapshot);
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Container();
        },
      ),
    );
  }

  Widget hasData(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: snapshot.data!.map((associato) {
            final prodotto = associato["product"];
            return Card(
              margin: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      prodotto["productImages"].isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 67),
                              child: Image.memory(
                                base64Decode(
                                    prodotto["productImages"][0]["content"]),
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 67),
                              height: 150,
                              width: 150,
                              color: Colors.grey,
                              child:
                                  const Center(child: Text("Nessuna immagine")),
                            ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${prodotto['name']}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(children: [Text('Marca: ${prodotto['brand']}')]),
                      Row(children: [Text('Prezzo: ${prodotto['price']}')]),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Quantità ordinata: ${associato['quantity']}')
                    ],
                  ),
                  Column(children: [
                    Text(
                      'Subtotale: ${associato['price'].toStringAsFixed(2)}',
                    )
                  ]),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}