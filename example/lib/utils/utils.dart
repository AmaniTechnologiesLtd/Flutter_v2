import 'package:flutter/material.dart';

void showSnackBar(BuildContext ctx, String text) {
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(text)));
}
