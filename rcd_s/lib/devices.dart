import 'package:flutter/material.dart';

class Devices extends StatefulWidget {
  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final List<String> data = <String>[
    "Twitter",
    "Reddit",
    "YouTube",
    "Facebook",
    "Vimeo",
    "GitHub",
    "GitLab",
    "BitBucket",
    "LinkedIn",
    "Medium",
    "Tumblr",
    "Instagram",
    "Pinterest"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Устройства'),
        actions: [
          IconButton(icon: Icon(Icons.dehaze_rounded), onPressed: _openMenu),
        ],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDevice,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _body() {
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          child: new GridTile(
            child: Text(data[index]),
            footer: Text('Комната'),
          ),
        );
      },
    );
  }

  void _openMenu() {}

  void _addDevice() {}
}
