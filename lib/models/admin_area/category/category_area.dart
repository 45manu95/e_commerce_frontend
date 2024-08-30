import 'package:flutter/material.dart';

import '../../other/super_components/app_bar.dart';
import 'components/category_table.dart';

class CategoryArea extends StatelessWidget {
  const CategoryArea(
      {required this.pageNumber,
      required this.pageSize,
      required this.search,
      required this.sort,
      super.key});

  final int pageNumber;
  final int pageSize;
  final String search;
  final String sort;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(area: "management_category", search: ""),
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: const Text(
                "Categorie",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TableCategory(
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                sort: sort),
          ],
        ),
      ),
    );
  }
}