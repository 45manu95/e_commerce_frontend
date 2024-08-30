// ignore: must_be_immutable
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce_frontend/data/product.dart';
import 'package:e_commerce_frontend/data/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_web_data_table/web_data_table.dart';

// ignore: must_be_immutable
class TableReviews extends StatefulWidget {
  TableReviews(
      {required this.pageNumber,
      required this.pageSize,
      required this.sort,
      required this.cfCliente,
      required this.idProduct,
      super.key});

  int pageNumber;
  int pageSize;
  String sort;
  String cfCliente;
  String idProduct;

  @override
  State<TableReviews> createState() => _TableReviewsState();
}

class _TableReviewsState extends State<TableReviews> {
  bool loadingAccess = false;

  List<String> _selectedRowKeys = [];

  final List<String> itemsNumber = [
    '10',
    '20',
    '50',
    '100',
  ];

  String selectedValue = "10";

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
    return FutureBuilder(
      future: (widget.cfCliente == "" && widget.idProduct == "")
          ? Review().data(
              widget.pageNumber, widget.pageSize, widget.sort, widget.cfCliente)
          : (widget.cfCliente != "" && widget.idProduct == "")
              ? Review().dataClientReviews(widget.pageNumber, widget.pageSize,
                  widget.sort, widget.cfCliente)
              : Product().dataReviewsProduct(widget.idProduct,
                  widget.pageNumber, widget.pageSize, widget.sort),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return noData();
          } else {
            return hasData(snapshot);
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return loadPage();
      },
    );
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

  Widget hasData(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            WebDataTable(
              header: const Text('Elenco'),
              actions: [
                if (_selectedRowKeys.isNotEmpty)
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.error)),
                      child: const Text(
                        'Elimina',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        showConfirmDialog();
                      },
                    ),
                  ),
              ],
              source: WebDataTableSource(
                columns: [
                  WebDataColumn(
                    name: 'id',
                    label: const Text('Id'),
                    dataCell: (value) => DataCell(Text(value.toString())),
                  ),
                  WebDataColumn(
                    name: 'userReview',
                    label: const Text('Cliente'),
                    dataCell: (value) => DataCell(Text('${value["cf"]}')),
                  ),
                  WebDataColumn(
                    name: 'reviewedProduct',
                    label: const Text('Prodotto Recensito'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'stars',
                    label: const Text('Valutazione'),
                    dataCell: (value) => DataCell(
                      Row(
                        children: List.generate(
                          value as int,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  WebDataColumn(
                    name: 'description',
                    label: const Text('Testo'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'date',
                    label: const Text('Data'),
                    dataCell: (value) => DataCell(Text('$value')),
                  )
                ],
                rows: snapshot.data as List<Map<String, dynamic>>,
                selectedRowKeys: _selectedRowKeys,
                onSelectRows: (keys) {
                  setState(() {
                    _selectedRowKeys = keys;
                  });
                },
                primaryKeyName: 'id',
              ),
              horizontalMargin: 15,
            ),
            Positioned(
              right: 5,
              bottom: 8,
              width: 850,
              height: 50,
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          "Numero Elementi",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "Pagina indietro",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface),
                          ))),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        if ((int.parse(selectedValue) - snapshot.data!.length ==
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "Pagina avanti",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface),
                          ))),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Nessun Risultato",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          (widget.pageNumber != 0)
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.pageNumber--;
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "Pagina indietro",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      )))
              : Container(),
        ],
      ),
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                                    color:
                                        Theme.of(context).colorScheme.surface),
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

  void showConfirmDialog() {
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
                      const Text(
                        "Conferma eliminazione",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Sei sicuro di voler eliminare le informazioni selezionate?",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                loadingAccess = false;
                              });
                              Review()
                                  .deleteRecensione(_selectedRowKeys, context);
                              setState(() {
                                _selectedRowKeys.clear();
                              });
                            },
                            child: Container(
                                width: 50,
                                margin: const EdgeInsets.only(left: 20),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: (loadingAccess)
                                    ? SpinKitCircle(
                                        size: 20,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return const DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                          );
                                        },
                                      )
                                    : Text(
                                        "SI",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
                                      )),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Text(
                                  "NO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          });
        });
  }
}
