import 'package:flutter/material.dart';

import '../../other/super_components/app_bar.dart';
import 'components/reviews_table.dart';

class ReviewsArea extends StatelessWidget {
  const ReviewsArea(
      {required this.cfCliente,
      required this.sort,
      required this.pageNumber,
      required this.pageSize,
      required this.idProduct,
      super.key});

  final int pageNumber;
  final int pageSize;
  final String sort;
  final String cfCliente;
  final String idProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(
        area: "management_reviews",
        search: "",
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: const Text(
                "Recensioni",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TableReviews(
                cfCliente: cfCliente,
                pageNumber: pageNumber,
                pageSize: pageSize,
                idProduct: idProduct,
                sort: sort),
          ],
        ),
      ),
    );
  }
}