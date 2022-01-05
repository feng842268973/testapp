import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      child: const Image(
        image: AssetImage("assets/images/home/home.png"),
        // width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover
      )
    );
  }
}