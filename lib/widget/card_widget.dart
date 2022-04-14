import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';

class CardWidget extends StatefulWidget {
  final Widget child;
  MaterialColor backgroundColor;
  double elevation;

  CardWidget({Key? key, required this.child, required this.backgroundColor, required this.elevation}) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}
class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Align( // you have to wrap in an align because it they are in another container, needed to change size
      child: SizedBox( 
        height: 150,
        width: 300,
        child: Card(
          color: widget.backgroundColor,
          elevation: widget.elevation,
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: widget.child
        ),
      ),
    );
  }
}