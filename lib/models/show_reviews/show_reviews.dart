// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:e_commerce_frontend/data/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../data/product.dart';
import '../../main.dart';
import '../admin_area/order_admin/show_products/show_products.dart';
import '../other/super_components/app_bar.dart';

// ignore: must_be_immutable
class ShowReviewScreen extends StatefulWidget {
  ShowReviewScreen({required this.prodotto, required this.idOrder, super.key});

  SampleDataRow prodotto;
  String idOrder;

  @override
  State<ShowReviewScreen> createState() => _ShowReviewScreenState();
}

class _ShowReviewScreenState extends State<ShowReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;

  double _valutazione = 0.0;
  var _testo = "default_value";

  void _trySubmitRecensione() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_valutazione == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci una valutazione')),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });
      Review()
          .addRecensione(_testo, _valutazione, userData.codiceFiscale,
              widget.prodotto.id, context)
          .then((value) {
        if (value == true) {
          setState(() {
            loadingAccess = true;
          });
          const snackBar = SnackBar(
            content: Text("Operazione eseguita!"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowProducts(idOrder: int.parse( widget.idOrder))));
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
    return Scaffold(
      appBar: SuperAppBar(area: "home_user", search: ""),
      body: Center(
        child: SizedBox(
          width: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Crea Recensione",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (widget.prodotto.productImages.isNotEmpty)
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 67),
                                child: Image.memory(
                                  base64Decode(
                                      widget.prodotto.productImages[0].picByte),
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
                                child: const Center(
                                    child: Text("Nessuna immagine")),
                              ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(widget.prodotto.nome,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("Valutazione Complessiva",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    RatingBar.builder(
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _valutazione = rating;
                      },
                    ),
                    const Divider(),
                    TextFormField(
                      maxLength: 250,
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Campo Obbligatorio";
                        }
                        return null;
                      }),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 50),
                        labelText: "Descrizione",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _testo = value!;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!loadingAccess) {
                          _trySubmitRecensione();
                        }
                      },
                      child: Container(
                        width: 90,
                        height: 47,
                        margin: const EdgeInsets.only(left: 30),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
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
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                  );
                                },
                              )
                            : const Text(
                                "Invia",
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
          ),
        ),
      ),
    );
  }
}

