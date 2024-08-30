// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:e_commerce_frontend/data/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../data/composition_cart.dart';
import '../../../../main.dart';
import '../../../other/super_components/app_bar.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({required this.prodotto, super.key});

  final SampleDataRow prodotto;

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool viewPreview = false;

  // ignore: non_constant_identifier_names
  Widget ShowReviewsProduct(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final recensione = snapshot.data![index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.person_pin_rounded),
                  const SizedBox(width: 20),
                  Text('${recensione['cliente']['nome']}'
                      ' ${recensione['cliente']['cognome']}')
                ],
              ),
              const SizedBox(height: 5),
              Row(children: [
                RatingBarIndicator(
                  rating: recensione['valutazione'],
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
                    '${recensione['testo']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Recensito il ${recensione['data']}',
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
        );
      },
    );
  }

  Widget noData() {
    return const Center(
      child: Text('Nessuna Recensione', style: TextStyle(fontSize: 16)),
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

  Widget buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }

  void _trySubmitProdottoCarrello() async {
    FocusScope.of(context).unfocus();
    ComposizioneCarrello()
        .addProdottoCarrello(
            widget.prodotto.id, userData.codiceFiscale, 1, context)
        .then((value) {
      if (value) {
        var snackBar = const SnackBar(
          content: Text("Prodotto aggiunto al Carrello"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var snackBar = const SnackBar(
          content: Text("Prodotto non disponibile"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SuperAppBar(
          area: "home_user",
          search: "",
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.prodotto.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      viewPreview = true;
                    }),
                    child: RatingBarIndicator(
                      rating: widget.prodotto.avgValutazione,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Descrizione:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.prodotto.descrizione,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Images:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.prodotto.productImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        base64Decode(
                            widget.prodotto.productImages[index].picByte),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '€${widget.prodotto.prezzo}',
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _trySubmitProdottoCarrello();
                },
                child: const Text('Aggiungi al Carrello'),
              ),
              const SizedBox(height: 25),
              const Text(
                'Dettagli Prodotto:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      buildTableCell('Codice Prodotto'),
                      buildTableCell(widget.prodotto.id),
                    ],
                  ),
                  TableRow(
                    children: [
                      buildTableCell('Marca'),
                      buildTableCell(widget.prodotto.marca),
                    ],
                  ),
                  TableRow(
                    children: [
                      buildTableCell('Categoria'),
                      buildTableCell(widget.prodotto.categoria.nome),
                    ],
                  ),
                  TableRow(
                    children: [
                      buildTableCell('Stato'),
                      buildTableCell(widget.prodotto.stato),
                    ],
                  ),
                  TableRow(children: [
                    buildTableCell('Prezzo'),
                    buildTableCell(widget.prodotto.prezzo.toString()),
                  ]),
                ],
              ),
              const SizedBox(height: 40),
              (viewPreview)
                  ? Expanded(
                      child: FutureBuilder(
                          future: Product().dataReviewsProduct(
                              widget.prodotto.id, 0, 10, "data"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return noData();
                              } else {
                                return ShowReviewsProduct(snapshot);
                              }
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return loadPage();
                          }),
                    )
                  : Container()
            ],
          ),
        ));
  }
}