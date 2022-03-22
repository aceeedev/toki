import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final bool padding;

  const PageTitle( {Key? key, required this.title, required this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: context.watch<Styles>().pageTitle
            ),
            SizedBox(
              width: title.length.toDouble() * 30,
              height: 7.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.watch<Styles>().selectedAccentColor,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}