// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

import '../../../data/user_client.dart';
import '../../../main.dart';
import '../../other/super_components/app_bar.dart';
import '../oder_area/order_area.dart';
import '../user_order_return/user_order_return.dart';
import '../user_reviews/user_reviews.dart';
import 'components/my_profile_component.dart';


class ProfileClientScreen extends StatelessWidget {
  const ProfileClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(area: "home_user", search: ""),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildClickableCard(
              'I Miei Ordini',
              'Visualizza i tuoi ordini, aggiungi recensioni e richiedi reso',
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyOrdersScreen(
                              cfCliente: userData.codiceFiscale,
                              filter: const [],
                              pageNumber: 0,
                              pageSize: 10,
                              sort: "id",
                              search: "",
                            )));
              },
            ),
            const SizedBox(height: 16.0),
            buildClickableCard(
              'I Miei Resi',
              'Visualizza i tuoi resi e gestisci le richieste di reso',
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyResoScreen(
                              cfCliente: userData.codiceFiscale,
                              filter: const [],
                              pageNumber: 0,
                              pageSize: 10,
                              sort: "id",
                              search: "",
                            )));
              },
            ),
            const SizedBox(height: 16.0),
            buildClickableCard(
              'Le Mie Recensioni',
              'Visualizza e gestisci le tue recensioni',
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyReviewsScreen(
                              cfCliente: userData.codiceFiscale,
                              pageNumber: 0,
                              pageSize: 10,
                              sort: "date",
                            )));
              },
            ),
            const SizedBox(height: 16.0),
            buildClickableCard(
              'Modifica Profilo',
              'Aggiorna le tue informazioni personali',
              () async {
                UserData user =
                    await UserClient().getCliente(userData.codiceFiscale, context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyUserProfileScreen(
                              cliente: user,
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClickableCard(
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}