// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../models/products/product_list/products_area.dart';
import '../models/home/home.dart';
import 'category.dart';
import 'image_data.dart';
import 'review.dart';
import 'user_type.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart'; 


class Product {
  int pageNumber = 0;
  int pageSize = 10;
  List<String> filter = [
    "",
    "",
    "",
  ];
  String sort = "barCode";
  String search = "";
  late Uri url;
  String idProduct = "";

  Future<List<Map<String, dynamic>>> data(int pageNumber, int pageSize,
      List<String> filter, String sort, String search) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort.trim();
    this.search = search;
    for (int k = 0; k < filter.length; k++) {
      this.filter[k] = filter[k].trim();
    }
    var list = await getData().then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

  Future<List<Map<String, dynamic>>> dataDeleteProducts(
      int pageNumber, int pageSize, String sort, String search) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.search = search;
    this.sort = sort.trim();
    var list = await getAllProdottiEliminati().then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

  Future<List<Map<String, dynamic>>> dataReviewsProduct(
      String idProduct, int pageNumber, int pageSize, String sort) async {
    this.idProduct = idProduct;
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort;
    var list = await getAllRecensioneProdotto(idProduct).then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

  Future<List<SampleDataRow>> getData() async {
    List<SampleDataRow> results = [];

    await Future.delayed(const Duration(milliseconds: 500));

    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";

    if (search != "" && search != "default_search") {
      if (userData.userType == UserType.admin) {
        url = Uri.parse(
            "http://localhost:8080/product/search/$search?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
      } else {
        url = Uri.parse(
            "http://localhost:8080/product/searchName/$search?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
      }
    } else if (filter[0] != "" || filter[1] != "" || filter[2] != "") {
      url = Uri.parse(
          "http://localhost:8080/product/filter?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort&quantity=${filter[0]}&state=${filter[1]}&category=${filter[2]}");
    } else {
      url = Uri.parse(
          "http://localhost:8080/product/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    }

    try {
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> prodotti = json.decode(request.body);
        for (var prodotto in prodotti) {
          results.add(SampleDataRow.fromJson(prodotto));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return results;
  }

  Future<List<SampleDataRow>> getAllProdottiEliminati() async {
    List<SampleDataRow> results = [];

    await Future.delayed(const Duration(milliseconds: 500));

    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";

    if (search != "" && search != "default_search") {
      url = Uri.parse(
          "http://localhost:8080/product/searchDelete/$search?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else {
      url = Uri.parse(
          "http://localhost:8080/product/all/onlyDelete?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    }

    try {
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> prodottiEliminati = json.decode(request.body);
        for (var prodotto in prodottiEliminati) {
          results.add(SampleDataRow.fromJson(prodotto));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return results;
  }

  Future<bool> addProduct(
    id,
    nome,
    marca,
    quantita,
    descrizione,
    prezzo,
    categoria,
    List<XFile> imageFiles,
    BuildContext context,
  ) async {
    String accessToken = userData.accessToken;
    try {
      var request = MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8080/product/add'),
      );

      request.headers['Access-Control-Allow-Origin'] = '*';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $accessToken';

      Map<String, dynamic> productData = {
        'barCode': id.trim(),
        'name': nome.trim(),
        'brand': marca.trim(),
        'quantity': int.parse(quantita),
        'description': descrizione.trim(),
        'price': double.parse(prezzo),
        'category': {'name': categoria.trim()}
      };

      request.fields['product'] = jsonEncode(productData);

    for (XFile file in imageFiles) {
      Uint8List bytes = await file.readAsBytes();
      String mimeType = await _getMimeType(file);

      var mimeTypeData = mimeType.split('/');
      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        bytes,
        filename: basename(file.path),
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));
    }




      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.statusCode);
        showResultDialog("Prodotto non aggiunto", context);
      }

      return false;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }

  Future<String> _getMimeType(XFile file) async {
  // Leggi i primi 12 byte del file
  List<int> bytes = await file.readAsBytes();
  String? mimeType = lookupMimeType('temp', headerBytes: bytes);

  // Restituisci il tipo MIME o un fallback se non è riuscito a determinarlo
  return mimeType ?? 'application/octet-stream';
}

  void deleteProducts(List<String> products, BuildContext context) async {
    String accessToken = userData.accessToken;
    List<String> selectedRowKeys = [];

    for (int i = 0; i < products.length; i++) {
      selectedRowKeys.add(products[i]);
    }
    try {
      for (int k = 0; k < selectedRowKeys.length; k++) {
        var request = await http.delete(
          Uri.parse(
              "http://localhost:8080/product/remove/${selectedRowKeys[k]}"),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Accept': '*/*'
          },
        );

        if (request.statusCode != 200) {
          var snackBar = SnackBar(
            content: Text(request.body),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
          return;
        }
      }
      Navigator.pop(context);
      showDeleteResultDialog("Eliminazione effettuata con successo!", context);
    } catch (e) {
      showDeleteResultDialog("Connessione internet assente", context);
    }
  }

  Future<bool> deleteProductsQuantity(
      String product, String quantity, BuildContext context) async {
    String accessToken = userData.accessToken;
    try {
      var request = await http.delete(
        Uri.parse("http://localhost:8080/product/remove/$product/$quantity"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*'
        },
      );

      if (request.statusCode != 200) {
        var snackBar = SnackBar(
          content: Text(request.body),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
        return false;
      }

      showResultDialog("Eliminazione effettuata con successo!", context);
      return true;
    } catch (e) {
      showResultDialog("Connessione internet assente", context);
    }
    return false;
  }

  Future<bool> aggiornaQuantita(
      String productID, String quantity, BuildContext context) async {
    String accessToken = userData.accessToken;
    try {
      var request = await http.put(
        Uri.parse(
            "http://localhost:8080/product/updateProductQuantity?barCode=$productID&newQuantity=$quantity"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*'
        },
      );
      if (request.statusCode == 400) {
        showResultDialog(request.body, context);
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> aggiornaPrezzo(
      String productID, String prezzo, BuildContext context) async {
    String accessToken = userData.accessToken;
    try {
      var request = await http.put(
        Uri.parse(
            "http://localhost:8080/product/updateProductPrice?barCode=$productID&newPrice=$prezzo"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*'
        },
      );
      if (request.statusCode == 400) {
        showResultDialog(request.body, context);
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void recuperaProdottoEliminato(
      List<String> products, BuildContext context) async {
    String accessToken = userData.accessToken;
    List<String> selectedRowKeys = [];

    for (int i = 0; i < products.length; i++) {
      selectedRowKeys.add(products[i]);
    }
    try {
      for (int k = 0; k < selectedRowKeys.length; k++) {
        var request = await http.put(
          Uri.parse(
              "http://localhost:8080/product/restore/${selectedRowKeys[k]}"),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Accept': '*/*'
          },
        );

        if (request.statusCode != 200) {
          var snackBar = SnackBar(
            content: Text(request.body),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
      }

      var snackBar = const SnackBar(
        content: Text("Recupero effettuato con successo"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      var snackBar = const SnackBar(
        content: Text("Connessione internet assente"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<List<ReviewData>> getAllRecensioneProdotto(
      String idProdotto) async {
    List<ReviewData> results = [];

    await Future.delayed(const Duration(milliseconds: 500));

    String accessToken = userData.accessToken;
    try {
      var request = await http.get(
        Uri.parse(
            "http://localhost:8080/product/$idProdotto/review/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*'
        },
      );

      if (request.statusCode == 200) {
        final List<dynamic> recensioni = json.decode(request.body);
        for (var recensione in recensioni) {
          results.add(ReviewData.fromJson(recensione));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return results;
  }

  void searchProduct(search, BuildContext context) {
    this.search = search.trim();
    Navigator.pop(context);
    if (userData.userType == UserType.admin) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductsArea(
                    cfCliente: "",
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                    search: search,
                    filter: filter,
                    sort: sort,
                    seeDeleteProducts: false,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    userData: userData,
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                    search: search,
                    sort: sort,
                    filter: const [],
                  )));
    }
  }

  void searchDeleteProduct(search, BuildContext context) {
    this.search = search.trim();
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsArea(
                  cfCliente: "",
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  search: search,
                  filter: filter,
                  sort: sort,
                  seeDeleteProducts: true,
                )));
  }

  showResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
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
  }

  showDeleteResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  }

  showFilterDialog(
      String quantita, String stato, String categoria, BuildContext context) {
    List<String> filterParameters = [
      quantita.toString(),
      stato.trim(),
      categoria.trim(),
    ];
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsArea(
                cfCliente: "",
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                filter: filterParameters,
                sort: sort,
                seeDeleteProducts: false)));
  }

  showSortDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return SimpleDialog(
            children: [
              const Text(
                "ORDINAMENTO",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50, right: 50),
                child: ElevatedButton(
                    onPressed: () {
                      sort = "quantita";
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
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
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(
                      "quantita",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      sort = "nome";
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
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
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(
                      "Nome prodotto",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      sort = "id";
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
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
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(
                      "ID Prodotto",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ))
            ],
          );
        }));
  }
}

class SampleDataRow {
  final String id;
  final int qta;
  final String nome;
  final String descrizione;
  final String marca;
  final CategoryData categoria;
  final double prezzo;
  final String stato;
  final double avgValutazione;
  final List<ImageData> productImages;

  SampleDataRow(
      {required this.id,
      required this.qta,
      required this.nome,
      required this.descrizione,
      required this.marca,
      required this.categoria,
      required this.prezzo,
      required this.stato,
      required this.avgValutazione,
      required this.productImages});

  factory SampleDataRow.fromJson(Map<String, dynamic> json) {
    List<ImageData> images = (json['productImages'] as List<dynamic>)
        .map((imageJson) => ImageData.fromJson(imageJson))
        .toList();
    return SampleDataRow(
      id: json["barCode"],
      nome: json["name"],
      marca: json["brand"],
      qta: json["quantity"],
      descrizione: json["description"],
      prezzo: json["price"],
      categoria: CategoryData.fromJson(json["category"]),
      stato: json["state"],
      avgValutazione: json["avgReview"],
      productImages: images,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> imageJsonList =
        productImages.map((image) => image.toJson()).toList();
    return {
      'barCode': id,
      'name': nome,
      'brand': marca,
      'quantity': qta,
      'description': descrizione,
      'price': prezzo,
      'state': stato,
      'category': {'name': categoria.getNome()},
      'productImages': imageJsonList,
      'avgReview': avgValutazione
    };
  }
}