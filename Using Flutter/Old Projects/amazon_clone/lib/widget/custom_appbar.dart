import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 217, 217, 217),
          border: Border(bottom: BorderSide(color: Colors.grey))),
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height / 99,
              ),
              SizedBox(
                width: size.width / 4,
                child: Image.asset('assets/images/amazon_logo.png',
                    fit: BoxFit.cover),
              ),
            ],
          ),
          SizedBox(
            width: size.width / 90,
          ),
          const Text(
            ".in",
            style: TextStyle(color: Colors.black, fontSize: 18),
          )
        ],
      ),
    );
  }
}
