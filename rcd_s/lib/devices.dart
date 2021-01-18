import 'package:flutter/material.dart';
import 'menu.dart';

class Devices extends StatefulWidget {
  Devices({Key key}) : super(key: key);

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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Устройства'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 60.0,
                width: MediaQuery.of(context).size.width,
                child: _block(),
              ),
              Expanded(
                child: _grid(),
              ),
            ],
          ),
        ),
        drawer: Menu('Устройства', context).menu,
        floatingActionButton: FloatingActionButton(
          onPressed: _addDevice,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _block() {
    String _sortValue = 'One';
    String _groupValue = 'One';

    return Row(
      children: <Widget>[
        Expanded(
          flex: 5, //50%
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Сортировать по '),
              DropdownButton<String>(
                value: _sortValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    _sortValue = newValue;
                  });
                },
                items: <String>['One', 'Two', 'Three', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5, //50%
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Группировать по '),
              DropdownButton<String>(
                value: _groupValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    _groupValue = newValue;
                  });
                },
                items: <String>['One', 'Two', 'Three', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _grid() {
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          child: InkWell(
              splashColor: Colors.indigo.withAlpha(30),
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(Icons.alarm),
                  new Text(data[index]),
                  new Text('Комната'),
                ],
              )),
        );
      },
    );
  }

  void _openMenu() {}

  void _addDevice() {}
}
