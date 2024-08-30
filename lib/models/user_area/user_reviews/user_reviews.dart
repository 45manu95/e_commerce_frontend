// ignore: must_be_immutable
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce_frontend/data/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../other/super_components/app_bar.dart';

// ignore: must_be_immutable
class MyReviewsScreen extends StatefulWidget {
  MyReviewsScreen(
      {required this.cfCliente,
      required this.pageNumber,
      required this.pageSize,
      required this.sort,
      super.key});

  String cfCliente;
  int pageNumber;
  int pageSize;
  String sort;

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  bool loadingAccess = false;
  final List<String> itemsNumber = [
    '10',
    '20',
    '50',
    '100',
  ];

  String selectedValue = "10";

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Review().dataClientReviews(
          widget.pageNumber, widget.pageSize, widget.sort, widget.cfCliente),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Scaffold(
                appBar: SuperAppBar(area: "home_user", search: ""),
                body: Column(children: [
                  const SizedBox(height: 20),
                  Expanded(child: noData())
                ]));
          } else {
            return Scaffold(
              appBar: SuperAppBar(area: "home_user", search: ""),
              body: Column(children: [
                const SizedBox(height: 20),
                Expanded(child: hasData(snapshot)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showPageSizeDialog();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(
                              "Numero Elementi",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surface),
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (widget.pageNumber != 0) {
                              setState(() {
                                widget.pageNumber--;
                              });
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: (widget.pageNumber != 0)
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                "Pagina indietro",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface),
                              ))),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            if ((int.parse(selectedValue) -
                                        snapshot.data!.length ==
                                    0) ||
                                snapshot.data!.isEmpty) {
                              setState(() {
                                widget.pageNumber++;
                              });
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: ((int.parse(selectedValue) -
                                                  snapshot.data!.length ==
                                              0) ||
                                          snapshot.data!.isEmpty)
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                "Pagina avanti",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface),
                              ))),
                    ],
                  ),
                ),
              ]),
            );
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return loadPage();
      },
    );
  }

  void showPageSizeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Numero di elementi visualizzabili"),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Seleziona numero',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: itemsNumber
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 190,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: IconStyleData(
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor:
                                Theme.of(context).colorScheme.surface,
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: WidgetStateProperty.all(6),
                              thumbVisibility: WidgetStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            stateNumRows();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                "CONFERMA",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface),
                              ))),
                    ],
                  ),
                )
              ],
            );
          });
        });
  }

  void stateNumRows() {
    setState(() {
      widget.pageSize = int.parse(selectedValue);
    });
  }

  Widget loadPage() {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        CircularProgressIndicator()
      ],
    ));
  }

  Widget noData() {
    return const Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Nessun Risultato",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget hasData(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final recensione = snapshot.data![index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.person_pin_rounded),
                      const SizedBox(width: 20),
                      Text('${recensione['userReview']['name']}'
                          ' ${recensione['userReview']['surname']}')
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(children: [
                    RatingBarIndicator(
                      rating: recensione['stars'],
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${recensione['description']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Recensito il ${recensione['date']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          List<String> recensioni = [];
                          recensioni.add(recensione["id"].toString());
                          Review().deleteRecensione(recensioni, context);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}