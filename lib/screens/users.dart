import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/screens/addUser.dart';
import 'package:rcd_s/screens/userDetail.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:rcd_s/services/globals.dart' as globals;

class Users extends StatefulWidget {
  Users({Key key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('users')),
      ),
      body: FutureBuilder(
        future: JsonService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                String key = snapshot.data.keys.elementAt(index);
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
                        /*leading: Icon(
                          Icons.supervised_user_circle,
                          color: Color.fromARGB(255, 56, 140, 203),
                          size: 40,
                        ),*/
                        leading: snapshot.data[key][1]
                            ? SvgPicture.asset(
                                'assets/SVG/admin.svg',
                                color: Color.fromARGB(255, 56, 140, 203),
                                width: 35,
                              )
                            : SvgPicture.asset(
                                'assets/SVG/user.svg',
                                color: Color.fromARGB(255, 56, 140, 203),
                                width: 35,
                              ),
                        title: Text(
                          "$key",
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: (snapshot.data[key][1])
                            ? Text(
                                AppLocalizations.of(context).translate('admin'))
                            : Text(
                                AppLocalizations.of(context).translate('user')),
                        onTap: () {
                          Navigator.of(context)
                              .push(_createRoute(snapshot.data[key], key));
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
          } else {
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
      ),
      drawer: Menu(AppLocalizations.of(context).translate('users'), context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: (globals.isAdmin)
            ? Theme.of(context).accentColor
            : Color.fromARGB(255, 170, 170, 170),
        onPressed: (globals.isAdmin) ? _addUser : null,
      ),
    );
  }

  void _addUser() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddUser();
    }));
  }
}

Route _createRoute(dynamic currentUser, String currentKey) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        UserDetail(currentUser, currentKey),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
