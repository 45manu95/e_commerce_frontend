// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce_frontend/data/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import '../../../../../data/composition_cart.dart';
import '../../../../../data/user_type.dart';
import '../../../../../main.dart';
import '../../../reviewsArea/reviews_area.dart';


// ignore: must_be_immutable
class TableProducts extends StatefulWidget {
  TableProducts(
      {required this.cfCliente,
      required this.pageNumber,
      required this.pageSize,
      required this.filter,
      required this.search,
      required this.sort,
      super.key});

  int pageNumber;
  int pageSize;
  List<String> filter;
  String sort;
  String search;
  String cfCliente;

  @override
  State<TableProducts> createState() => _TableProductsState();
}

class _TableProductsState extends State<TableProducts> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;

  List<String> _selectedRowKeys = [];

  final List<String> itemsNumber = [
    '10',
    '20',
    '50',
    '100',
  ];
  String selectedValue = "10";
  String _quantita = "";
  String _prezzo = "";

  void _trySubmitProdottoCarrello() async {
    FocusScope.of(context).unfocus();
    for(int k=0; k<_selectedRowKeys.length;k++) {
          ComposizioneCarrello()
        .addProdottoCarrello(
            _selectedRowKeys[k], widget.cfCliente, 1, context)
        .then((value) {
      if (value) {
        var snackBar = const SnackBar(
          content: Text("Prodotto aggiunto al Carrello"),
        );
        _selectedRowKeys.clear();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        _selectedRowKeys.clear();
      }
    });
    }
  }

  void _trySubmit(bool function) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      if (function) {
        Product()
            .aggiornaQuantita(_selectedRowKeys.first, _quantita, context)
            .then((value) {
          if (value) {
            Navigator.pop(context);
            var snackBar = const SnackBar(
              content: Text("Numero elementi aggiornato"),
            );
            _selectedRowKeys.clear();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            Navigator.pop(context);
            var snackBar = const SnackBar(
              content: Text("Errore generico"),
            );
            _selectedRowKeys.clear();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
      } else {
        Product()
            .deleteProductsQuantity(_selectedRowKeys.first, _quantita, context);
      }
    }
  }

  void _trySubmitPrezzo() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      Product()
          .aggiornaPrezzo(_selectedRowKeys.first, _prezzo, context)
          .then((value) {
        if (value) {
          Navigator.pop(context);
          var snackBar = const SnackBar(
            content: Text("Prezzo aggiornato"),
          );
          _selectedRowKeys.clear();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          Navigator.pop(context);
          var snackBar = const SnackBar(
            content: Text("Errore generico"),
          );
          _selectedRowKeys.clear();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

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
      future: Product().data(widget.pageNumber, widget.pageSize, widget.filter,
          widget.sort, widget.search),
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
              availableRowsPerPage: const [10, 20, 50, 100],
              rowsPerPage: int.parse(selectedValue),
              header: const Text('Elenco'),
              actions: [
                if (_selectedRowKeys.isNotEmpty && userData.getType() == UserType.admin)
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Aggiorna Quantità',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        showQuantityDialog(true);
                      },
                    ),
                  ),
                if (_selectedRowKeys.isNotEmpty && userData.getType() == UserType.user)
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Aggiungi al Carrello',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _trySubmitProdottoCarrello();
                      },
                    ),
                  ),
                if (_selectedRowKeys.length == 1 && userData.getType() == UserType.admin)
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Rimuovi Quantità',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        showQuantityDialog(false);
                      },
                    ),
                  ),
                if (_selectedRowKeys.length == 1 && userData.getType() == UserType.admin)
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Aggiorna Prezzo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        showPrezzoDialog();
                      },
                    ),
                  ),
                if (_selectedRowKeys.length == 1)
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Visualizza Recensioni',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewsArea(
                                      cfCliente: "",
                                      pageNumber: widget.pageNumber,
                                      pageSize: widget.pageSize,
                                      sort: "data",
                                      idProduct: _selectedRowKeys.first,
                                    )));
                      },
                    ),
                  ),
                if (_selectedRowKeys.isNotEmpty && userData.getType() == UserType.admin)
                  SizedBox(
                    height: 50,
                    width: 100,
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
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Ricerca Prodotto',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      widget.search = value;
                      Product().searchProduct(value, context);
                    },
                  ),
                ),
              ],
              source: WebDataTableSource(
                columns: [
                  WebDataColumn(
                    name: 'barCode',
                    label: const Text('ID'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'name',
                    label: const Text('Nome Prodotto'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'quantity',
                    label: const Text('Quantità'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'brand',
                    label: const Text('Marca'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'description',
                    label: const Text('Descrizione'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'state',
                    label: const Text('Stato'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'price',
                    label: const Text('Prezzo'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'category',
                    label: const Text('Categoria'),
                    dataCell: (value) => DataCell(Text('${value['name']}')),
                  ),
                ],
                rows: snapshot.data as List<Map<String, dynamic>>,
                selectedRowKeys: _selectedRowKeys,
                onSelectRows: (keys) {
                  setState(() {
                    _selectedRowKeys = keys;
                  });
                },
                primaryKeyName: 'barCode',
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
                                color:
                                    Theme.of(context).colorScheme.surface),
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
                                color:
                                    Theme.of(context).colorScheme.surface),
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

  ///[function] indica con true l'aggiunta di nuove quantità e con false la rimozione delle quantità
  void showQuantityDialog(bool function) {
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
                      (function)
                          ? const Text("Aggiorna Quantità")
                          : const Text("Rimuovi Quantità"),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                maxLength: 5,
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return "Campo Obbligatorio";
                                  }
                                  if (double.tryParse(value) == null) {
                                    return "Concessi solo numeri";
                                  }
                                  if (int.parse(value) <= 0) {
                                    return "Il valore deve essere positivo";
                                  }

                                  return null;
                                }),
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: "Numero elementi",
                                  border: OutlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _quantita = value!;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!loadingAccess) {
                                  _trySubmit(function);
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 47,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.shadow,
                                      offset: const Offset(0.0, 1.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
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
                                    : const Text(
                                        "Conferma",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ])),
                    ],
                  ),
                )
              ],
            );
          });
        });
  }

  void showPrezzoDialog() {
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
                      const Text("Aggiorna Prezzo"),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                maxLength: 5,
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return "Campo Obbligatorio";
                                  }
                                  if (double.tryParse(value) == null) {
                                    return "Concessi solo numeri";
                                  }
                                  if (double.parse(value) <= 0) {
                                    return "Concessi solo numeri positivi";
                                  }
                                  return null;
                                }),
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: "Prezzo",
                                  border: OutlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _prezzo = value!;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!loadingAccess) {
                                  _trySubmitPrezzo();
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 47,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.shadow,
                                      offset: const Offset(0.0, 1.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
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
                                    : const Text(
                                        "Conferma",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ])),
                    ],
                  ),
                )
              ],
            );
          });
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
                              Product()
                                  .deleteProducts(_selectedRowKeys, context);
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