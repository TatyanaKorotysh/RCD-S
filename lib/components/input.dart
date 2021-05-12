import 'package:flutter/material.dart';

Widget input(String lable, TextInputType type, TextEditingController controller,
    bool hide, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.85,
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
