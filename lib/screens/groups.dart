import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/screens/deviceDetail.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/services/globals.dart' as globals;

class Groups extends StatefulWidget {
  Groups({Key key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  CommandManager commandManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //subscription.cancel();
    super.dispose();
  }

  // ignore: top_level_function_literal_block
  var sortList = <String>["one", "two", "three"].map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      child: new Text(value),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    commandManager = Provider.of<CommandManager>(context);
    commandManager.sendReadGroupsCommand();
    return _body();
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Группы'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                //height: 60.0,
                //width: MediaQuery.of(context).size.width,
                //child: _filter(),
                ),
            Expanded(
              child: _list(),
            ),
          ],
        ),
      ),
      drawer: Menu(AppLocalizations.of(context).translate('devices'), context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          (globals.isAdmin) ? _addDevice : null;
        },
        backgroundColor: (globals.isAdmin)
            ? Theme.of(context).accentColor
            : Color.fromARGB(255, 170, 170, 170),
      ),
    );
  }

  Widget _filter() {
    String _sortValue = 'one';
    String _groupValue = 'one';

    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Сортировать по "),
            items: sortList,
            value: _sortValue,
            onChanged: (String val) => setState(() => _sortValue = val),
          ),
        ),
        Expanded(
          flex: 5,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Группировать по "),
            items: sortList,
            value: _groupValue,
            onChanged: (String val) => setState(() => _groupValue = val),
          ),
        )
      ],
    );
  }

  Widget _list() {
    return StreamBuilder(
      stream: commandManager.groupListStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(40, 56, 140, 203),
                            spreadRadius: 0.5,
                            blurRadius: 0.5,
                            offset: Offset(1, 1)),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment(0, 0),
                        end: Alignment(-3, -15),
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Color.fromARGB(255, 200, 200, 200),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListTile(
                      leading: Icon(
                        Icons.device_unknown_rounded,
                        color: Color.fromARGB(255, 56, 140, 203),
                        size: 40,
                      ),
                      title: Text(
                        snapshot.data[index].name,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(snapshot.data[index].id.toString()),
                      onTap: () {
                        //Navigator.of(context)
                        //   .push(_createRoute(snapshot.data[key], key));
                        /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserDetail(snapshot.data[key], key);
                    }));*/
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              );
            },
          );
        } else
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/img/preloader.gif"),
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Text(AppLocalizations.of(context).translate('loadingData')),
            ],
          );
      },
    );
  }

  void _addDevice() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return AddDevice();
    }));
  }
}
