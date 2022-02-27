import 'package:flutter/material.dart';
import 'styles.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 80.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: Styles.pageTitle
        ),
      ),
    );
  }
}