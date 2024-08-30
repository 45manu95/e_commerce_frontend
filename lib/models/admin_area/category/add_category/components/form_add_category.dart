import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../data/category.dart';
import '../../category_area.dart';


class FormAddCategory extends StatefulWidget {
  const FormAddCategory({super.key});

  @override
  State<FormAddCategory> createState() => _FormAddCategoryState();
}

class _FormAddCategoryState extends State<FormAddCategory> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;
  int pageNumber = 0;
  int pageSize = 10;
  String search = "";
  String sort = "name";

  var _nome = "default_value";


  void _trySubmitCategory() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });
      Category().addCategoria(_nome, context).then((value){
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
                  builder: (context) => CategoryArea(
                        pageNumber: pageNumber,
                        pageSize: pageSize,
                        search: search,
                        sort: sort,
                      )));
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
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  if (!loadingAccess) {
                    _trySubmitCategory();
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