import 'package:cuts/login/verify_phone_number_screen.dart';
import 'package:cuts/utils/globals.dart';
import 'package:cuts/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AboutYouPage extends StatefulWidget {
  const AboutYouPage({super.key});

  @override
  State<AboutYouPage> createState() => _AboutYouPageState();
}

class _AboutYouPageState extends State<AboutYouPage> {
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  TextEditingController txtNome = TextEditingController(),
      txtDate = TextEditingController();

  @override
  void initState() {
    txtNome.text = Globals.firebaseUser!.displayName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller: txtNome,
                        maxLines: 1,
                        decoration: InputDecoration(
                            label: Text('Nombre'),
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: txtDate,
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Fecha de Nacimiento')),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: Jiffy().subtract(years: 12).dateTime,
                              firstDate: DateTime(
                                  1930), //DateTime.now() - not to allow to choose before today.
                              lastDate: Jiffy().subtract(years: 12).dateTime);

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              txtDate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Fecha no seleccionada");
                          }
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      IntlPhoneField(
                        autofocus: false,
                        invalidNumberMessage: 'Nº de movil inválido!',
                        textAlignVertical: TextAlignVertical.center,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        style: const TextStyle(fontSize: 25),
                        onChanged: (phone) {
                          setState(() {
                            phoneNumber = phone.completeNumber;
                          });
                        },
                        initialCountryCode: 'ES',
                        flagsButtonPadding: const EdgeInsets.only(right: 10),
                        showDropdownIcon: false,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            if (isNullOrBlank(phoneNumber) ||
                                !_formKey.currentState!.validate()) {
                              showSnackBar(
                                  'Introduzca un número de movil válido!');
                            } else {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              print(txtNome.text + txtDate.text + phoneNumber!);
                              prefs.setString('nome', txtNome.text);
                              prefs.setString('dt', txtDate.text);
                              prefs.setString('movil', phoneNumber!);

                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      VerifyPhoneNumberScreen(
                                    phoneNumber: phoneNumber.toString(),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Continuar'),
                      ),
                    ],
                  ),
                ))));
  }
}
