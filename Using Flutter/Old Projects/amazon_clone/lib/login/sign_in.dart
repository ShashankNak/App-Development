import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class SignInFields extends StatefulWidget {
  const SignInFields({super.key});

  @override
  State<SignInFields> createState() => _SignInFieldsState();
}

class _SignInFieldsState extends State<SignInFields> {
  final TextEditingController phoneController = TextEditingController();
  bool isNumber = false;
  bool isTyped = false;
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "India",
      e164Key: "");

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length));
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height / 90,
        ),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {
              try {
                phoneController.text = value;
                isTyped = value.isNotEmpty;
                isNumber = value.isNotEmpty &&
                    (int.parse(value[0]) > 0 && int.parse(value[0]) < 9);
              } catch (e) {
                isNumber = false;
              }
            });
          },
          autocorrect: false,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            suffixIcon: isTyped
                ? phoneController.text.length > 9
                    ? Container(
                        height: size.height / 70,
                        width: size.width / 70,
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          phoneController.clear();
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        ),
                      )
                : null,
            prefixIcon: isNumber
                ? Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width / 5.5,
                    height: size.height / 14,
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          countryListTheme: CountryListThemeData(
                              bottomSheetHeight: size.height / 2),
                          onSelect: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                        );
                      },
                      child: Center(
                        child: Text(
                          "${selectedCountry.countryCode} ${selectedCountry.phoneCode}",
                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 13),
                        ),
                      ),
                    ),
                  )
                : null,
            hintText: "Email or Phone Number",
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.zero),
              borderSide: const BorderSide(
                  width: 1.5, color: Color.fromARGB(143, 33, 208, 243)),
              gapPadding: size.width / 99,
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.zero),
              borderSide: const BorderSide(width: 1.5, color: Colors.black),
              gapPadding: size.width / 99,
            ),
          ),
        ),
        SizedBox(
          height: size.height / 40,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Colors.amber.shade400,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            fixedSize: Size(size.width / 1.15, size.height / 15),
          ),
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(
          height: size.height / 40,
        ),
        RichText(
          text: const TextSpan(
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
              children: [
                TextSpan(text: "By Continuing, you agree to Amazon's "),
                TextSpan(
                    text: "Conditions of Use ",
                    style: TextStyle(color: Colors.blue)),
                TextSpan(text: "and "),
                TextSpan(
                    text: "Privacy Notice",
                    style: TextStyle(color: Colors.blue)),
              ]),
        ),
      ],
    );
  }
}
