import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/components/choiceAlert.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/components/simpleAlert.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/models/group.dart';
import 'package:rcd_s/screens/deviceDetail.dart';
import 'package:rcd_s/screens/groupDevices.dart';
import 'package:rcd_s/services/isConnect.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/services/globals.dart' as globals;
import 'package:rcd_s/storage/group_storage.dart';

class Groups extends StatefulWidget {
  Groups({Key key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  CommandManager commandManager;
  GroupLocalStorage groupLocalStorage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IsConnect.initConnectivity(context);

    groupLocalStorage = Provider.of<GroupLocalStorage>(context);
    groupLocalStorage.getAllGroupList();
    commandManager = Provider.of<CommandManager>(context);
    //commandManager.sendReadGroupsCommand();
    return _body();
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('groups')),
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
      drawer: Menu(AppLocalizations.of(context).translate('groups'), context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          (globals.isAdmin) ? _addGroup() : null;
        },
        backgroundColor: (globals.isAdmin)
            ? Theme.of(context).accentColor
            : Color.fromARGB(255, 170, 170, 170),
      ),
    );
  }

  Widget _list() {
    return StreamBuilder(
      stream: groupLocalStorage.groupListStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return Center(
                child: Text(
              "Список пуст",
              style: TextStyle(fontSize: 16),
            ));
          else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      padding: EdgeInsets.all(10),
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
                      child: InkWell(
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                      'assets/SVG/group.svg',
                                      color: Color.fromARGB(255, 56, 140, 203),
                                      width: 50,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].name,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        Text(
                                          snapshot.data[index].id.toString(),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  128, 128, 128, 128),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  (globals.isAdmin)
                                      ? _deleteGroup(snapshot.data[index])
                                      : null;
                                },
                                padding: EdgeInsets.only(bottom: 60),
                                color: (globals.isAdmin)
                                    ? Color.fromARGB(150, 56, 140, 203)
                                    : Color.fromARGB(50, 128, 128, 128),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(_createRoute(
                                snapshot.data[index], commandManager));
                          }),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                );
                /*return Column(
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
                      /*leading: Icon(
                        Icons.device_unknown_rounded,
                        color: Color.fromARGB(255, 56, 140, 203),
                        size: 40,
                      ),*/
                      leading: SvgPicture.asset(
                        'assets/SVG/group.svg',
                        color: Color.fromARGB(255, 56, 140, 203),
                        width: 35,
                      ),
                      title: Text(
                        snapshot.data[index].name,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(snapshot.data[index].id.toString()),
                      onTap: () {
                        Navigator.of(context).push(
                            _createRoute(snapshot.data[index], commandManager));
                        /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserDetail(snapshot.data[key], key);
                    }));*/
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              );*/
              },
            );
        } else {
          groupLocalStorage.getAllGroupList();
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
        }
      },
    );
  }

  void _addGroup() {
    //print(groupLocalStorage.getAllGroupList());
    int i = groupLocalStorage.getAllGroupList().length;
    i++;
    commandManager.sendCreateGroupCommand(i);
  }

  _deleteGroup(Group group) {
    if (groupLocalStorage.getDevicesIds(group).length == 0) {
      choiceAlert(
          AppLocalizations.of(context).translate('groupDelete'),
          AppLocalizations.of(context).translate('groupDeleteNote'),
          AppLocalizations.of(context).translate('delete'), () {
        commandManager.sendDeleteGroupCommand(group);
      }, context);
    } else {
      simpleAlert(AppLocalizations.of(context).translate('groupDelete'),
          "Невозвожно удалить группу, так как она не пустая", context);
    }
  }

  Route _createRoute(Group currentGroup, CommandManager curManager) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          GroupDevices(currentGroup, curManager),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
