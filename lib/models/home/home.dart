import 'package:flutter/material.dart';
import '../../data/user_type.dart';
import '../other/super_components/app_bar.dart';
import '../products/table_products/product_area_user.dart';
import 'components/main_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.userData,
      required this.pageNumber,
      required this.pageSize,
      required this.search,
      required this.sort,
      required this.filter,
      super.key});

  final User userData;
  final int pageNumber;
  final int pageSize;
  final String search;
  final String sort;
  final List<String> filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (userData.getType == UserType.admin) ? SuperAppBar(area: "home_admin", search: '',) :  SuperAppBar(area: "home_user", search: '',),
      drawer: (userData.getType() == UserType.admin) ? MainDrawer() : null,
      body: (userData.getType() != UserType.admin) ? ProductsAreaUser(pageNumber: pageNumber, pageSize: pageSize, filter: filter, search: search, sort: sort,) : const Center(child: Text("Benvenuto ADMIN, seleziona il menu in alto a destra"),),
    );
  }
}