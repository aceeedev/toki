import 'package:flutter/material.dart';
import 'styles.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 80.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: Styles.pageTitle
            ),
            SizedBox(
              width: title.length.toDouble() * 30,
              height: 7.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Styles.selectedAccentColor,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}