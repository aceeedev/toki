import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';

class CardWidget extends StatelessWidget {
  final Widget child;

  const CardWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align( // you have to wrap in an align because it they are in another container, needed to change size
      child: SizedBox( 
        height: 150,
        width: 300,
        child: Card(
          color: context.watch<Styles>().secondBackgroundColor,
          elevation: 2.0,
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: child
        ),
      ),
    );
  }
}