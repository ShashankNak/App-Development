import 'package:amazon_clone/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';

class CreateAccountFields extends StatefulWidget {
  const CreateAccountFields({super.key});

  @override
  State<CreateAccountFields> createState() => _CreateAccountFieldsState();
}

class _CreateAccountFieldsState extends State<CreateAccountFields> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  var _enteredName = "";
  var _enteredPassword = "";
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
  bool showPassword = false;
  Map<String, bool> isTyped = {
    "name": false,
    "mobile": false,
    "password": false,
  };

  void _submit() {
    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();

    _formkey.currentState!.save();
    sendPhoneNumber();
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber",
        _enteredName, _enteredPassword);
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length));
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formkey,
      child: Column(
        children: [
          SizedBox(
            height: size.height / 80,
          ),
          TextFormField(
            onSaved: (newValue) {
              _enteredName = newValue!;
            },
            onChanged: (value) {
              setState(() {
                isTyped['name'] = value.isNotEmpty;
              });
            },
            keyboardType: TextInputType.name,
            autocorrect: false,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              suffixIcon: isTyped["name"]!
                  ? GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      ),
                    )
                  : null,
              hintText: "First and Last Name",
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                borderSide: const BorderSide(
                    width: 1.5, color: Color.fromARGB(143, 33, 208, 243)),
                gapPadding: size.width / 99,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                borderSide: const BorderSide(width: 1.5, color: Colors.black),
                gapPadding: size.width / 99,
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          Row(
            children: [
              GestureDetector(
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
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width / 3.1,
                    height: size.height / 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(255, 197, 197, 197)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${selectedCountry.countryCode} ${selectedCountry.phoneCode}",
                            style: const TextStyle(
                                color: Colors.blueAccent, fontSize: 13),
                          ),
                          SizedBox(
                            height: 12,
                            width: 12,
                            child: Image.asset(
                              "assets/images/arrow.png",
                              color: const Color.fromARGB(255, 63, 63, 63),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width / 30,
              ),
              Expanded(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value.trim();
                      isTyped['mobile'] = value.isNotEmpty;
                    });
                  },
                  autocorrect: false,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: isTyped['mobile']!
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
                    hintText: "Mobile Number",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: const BorderSide(
                          width: 1.5, color: Color.fromARGB(143, 33, 208, 243)),
                      gapPadding: size.width / 99,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide:
                          const BorderSide(width: 1.5, color: Colors.black),
                      gapPadding: size.width / 99,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height / 50,
          ),
          TextFormField(
            onSaved: (newValue) {
              _enteredPassword = newValue!;
            },
            onChanged: (value) {
              setState(() {
                isTyped['password'] = value.isNotEmpty;
              });
            },
            keyboardType: TextInputType.visiblePassword,
            autocorrect: false,
            cursorColor: Colors.black,
            obscureText: !showPassword,
            decoration: InputDecoration(
              suffixIcon: isTyped["password"]!
                  ? GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      ),
                    )
                  : null,
              hintText: "Set Password",
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                borderSide: const BorderSide(
                    width: 1.5, color: Color.fromARGB(143, 33, 208, 243)),
                gapPadding: size.width / 99,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                borderSide: const BorderSide(width: 1.5, color: Colors.black),
                gapPadding: size.width / 99,
              ),
            ),
          ),
          SizedBox(
            height: size.height / 100,
          ),
          const Row(
            children: [
              Icon(
                Icons.info_outlined,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Passwords must be aleast 6 characters.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: showPassword,
                  onChanged: (value) {
                    setState(() {
                      showPassword = value!;
                    });
                  },
                  checkColor: Colors.amber.shade400,
                  // activeColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black;
                    }
                    return Colors.black;
                  }),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(
                width: 0,
              ),
              const Text(
                "Show Password",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const Text(
            "By enrolling your mobile Phone number,  you consent to receive automated security notifications via text message from Amazon. Message and data rates may apply.",
            style: TextStyle(fontSize: 17.5),
          ),
          SizedBox(
            height: size.height / 90,
          ),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              elevation: 10,
              backgroundColor: Colors.amber.shade400,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              fixedSize: Size(size.width / 1.15, size.height / 18),
            ),
            child: const Text(
              "Verify mobile number",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: size.height / 40,
          ),
          RichText(
            text: const TextSpan(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                      text:
                          "By creating an account or logging in, you agree to Amazon's "),
                  TextSpan(
                      text: "Conditions of Use ",
                      style: TextStyle(color: Colors.blue)),
                  TextSpan(text: "and "),
                  TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: Colors.blue)),
                ]),
          ),
        ],
      ),
    );
  }
}
