import 'package:flutter/material.dart';

Widget input(String lable, TextInputType type, TextEditingController controller,
    bool hide) {
  return Container(
    child: TextFormField(
      decoration: new InputDecoration(labelText: lable),
      keyboardType: type,
      controller: controller,
      obscureText: hide,
      // validator: (value) => (value.isEmpty) ? 'Поле пустое' : null,
    ),
    padding: EdgeInsets.symmetric(vertical: 16.0),
  );
}
