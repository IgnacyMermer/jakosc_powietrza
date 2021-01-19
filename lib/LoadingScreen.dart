import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.red,
          size: 50.0,
        ),
      ),
    );
  }
}
