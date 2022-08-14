import 'package:flutter/material.dart';
import 'package:mqtt/localisation/localisation.dart';

void showSimpleAlert(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(Localisation.of(context).close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

void showErrorAlert(
  BuildContext context, {
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Localisation.of(context).error),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(Localisation.of(context).close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
