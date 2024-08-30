// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce_frontend/data/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import '../../../admin_area/category/select_category/select_category.dart';
import '../../product_list/products_area.dart';

class FormAddProduct extends StatefulWidget {
  const FormAddProduct({super.key});

  @override
  State<FormAddProduct> createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;
  bool categoryIsSelected = false;
  int pageNumber = 0;
  int pageSize = 10;
  String search = "";
  List<String> filter = [];
  String sort = "id";
  // ignore: prefer_final_fields
  List<XFile> _images = [];
  int _currentPage = 0;
  final _picker = ImagePicker();

  var _id = "default_value";
  var _quantita = "default_value";
  var _nome = "default_value";
  var _marca = "default_value";
  var _prezzo = "default_value";

  var _descrizione = "default_value";
  var _categoria = "default_value";

  Future<void> _pickImage() async {
    try {
      XFile? img = await _picker.pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          _images.add(img);
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Errore durante la selezione dell'immagine: $e");
    }
  }

  void _trySubmitProducts() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });

      Product()
          .addProduct(_id, _nome, _marca, _quantita, _descrizione, _prezzo,
              _categoria, _images, context)
          .then((value) {
        if (value == true) {
          setState(() {
            loadingAccess = true;
            _images.clear();
          });
          const snackBar = SnackBar(
            content: Text("Operazione eseguita!"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductsArea(
                      cfCliente: "",
                      pageNumber: pageNumber,
                      pageSize: pageSize,
                      search: search,
                      filter: filter,
                      sort: sort,
                      seeDeleteProducts: false)));
        } else {
          setState(() {
            loadingAccess = false;
          });
        }
      });
    }
  }

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: _images.length + 10,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (index >= _images.length || _images.isEmpty) {
                      return GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 40.0,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          margin: const EdgeInsets.all(8.0),
                          child: (_currentPage <= _images.length - 1)
                              ? Image.network(
                                  _images[_currentPage].path,
                                  fit: BoxFit.cover,
                                )
                              : Container());
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Campo Obbligatorio";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Codice a barre",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _id = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 10,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Campo Obbligatorio";
                  }
                  if (int.tryParse(value) == null) {
                    return "Concessi solo numeri";
                  }
                  if (int.parse(value) <= 0) {
                    return "Inserire un valore positivo";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Quantità",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _quantita = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 40,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Campo Obbligatorio";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _nome = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Campo Obbligatorio";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Marca",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _marca = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 10,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Campo Obbligatorio";
                  }
                  if (double.tryParse(value) == null) {
                    return "Concessi solo numeri";
                  }
                  if (double.parse(value) <= 0) {
                    return "Inserire un valore positivo";
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
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 250,
                validator: ((value) {
                  return null;
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Descrizione",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _descrizione = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              (categoryIsSelected)
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        "categoria selezionata",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SelectCategory(
                                      pageNumber: 0,
                                      pageSize: 10,
                                      filter: const [],
                                      sort: "nome",
                                      function: (String nomeCategoria) {
                                        setState(() {
                                          categoryIsSelected = true;
                                          _categoria = nomeCategoria;
                                        });
                                      },
                                      search: search,
                                    ))));
                      },
                      child: Container(
                        width: 200,
                        height: 47,
                        margin: const EdgeInsets.only(left: 30),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: (loadingAccess)
                            ? SpinKitCircle(
                                size: 20,
                                itemBuilder: (BuildContext context, int index) {
                                  return const DecoratedBox(
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                  );
                                },
                              )
                            : const Text(
                                "Aggiungi Categoria",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  if (!loadingAccess) {
                    _trySubmitProducts();
                  }
                },
                child: Container(
                  width: 90,
                  height: 47,
                  margin: const EdgeInsets.only(left: 30),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: (loadingAccess)
                      ? SpinKitCircle(
                          size: 20,
                          itemBuilder: (BuildContext context, int index) {
                            return const DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                            );
                          },
                        )
                      : const Text(
                          "Aggiungi",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ],
    );
  }
}