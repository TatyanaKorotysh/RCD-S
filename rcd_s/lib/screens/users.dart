import 'package:flutter/material.dart';
import 'package:rcd_s/components/menu.dart';
import 'package:rcd_s/screens/addUser.dart';
import 'package:rcd_s/screens/userDetail.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';

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
                return ListTile(
                  title: Text("$key"),
                  subtitle: (snapshot.data[key][1])
                      ? Text(AppLocalizations.of(context).translate('admin'))
                      : Text(AppLocalizations.of(context).translate('user')),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserDetail(snapshot.data[key], key);
                    }));
                  },
                );
              },
            );
          } else {
            return Center(
              child:
                  Text(AppLocalizations.of(context).translate('loadingData')),
            );
          }
        },
      ),
      drawer: Menu(AppLocalizations.of(context).translate('users'), context),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addUser() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddUser();
    }));
  }
}
