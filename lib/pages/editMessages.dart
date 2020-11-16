import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:freshgrownweb/services/admin_database_services.dart';
import 'package:freshgrownweb/shared/constants.dart';

class EditAdminMessages extends StatefulWidget {
  @override
  _EditAdminMessagesState createState() => _EditAdminMessagesState();
}

class _EditAdminMessagesState extends State<EditAdminMessages> {
  AdminServices _adminServices = AdminServices();
  List adminMessages = [];
  bool firstTime = true;

  Future<List<dynamic>> futureFunction() async {
    var result = [];
    var _temp = await _adminServices.getLocations();
    result.add(await _adminServices.getAdminDetails());
    result.add(_temp.docs.map((doc) {
      return doc.data();
    }).toList());

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: FutureBuilder<List<dynamic>>(
          future: futureFunction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (adminMessages.isEmpty && firstTime) {
                adminMessages = snapshot.data[0].get('messages');
                firstTime = false;
              }
              return Scaffold(
                backgroundColor: appBgColor,
                appBar: AppBar(
                  backgroundColor: appBarColor,
                ),
                body: ListView(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  children: [
                    Column(
                      children: adminMessages
                          .asMap()
                          .keys
                          .map((msg) => Container(
                                height: 80.0,
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                          text: adminMessages[msg],
                                        ),
                                        decoration:
                                            textInputDecoration.copyWith(
                                                hintText: 'Message',
                                                labelText: 'message'),
                                        onChanged: (value) {
                                          adminMessages[msg] = value;
                                        },
                                      ),
                                    ),
                                    Container(
                                        width: 50.0,
                                        child: IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              adminMessages.removeAt(msg);
                                            });
                                          },
                                        ))
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          adminMessages.add("");
                        });
                      },
                    ),
                    FlatButton(
                      color: appBarColor,
                      onPressed: () async {
                        bool result = await _adminServices.updateAdminMessages(
                            messages: adminMessages);
                        if (result) {
                          myToast('Successfully saved.');
                          Navigator.pop(context);
                        } else {
                          myToast("Failed operation.");
                        }
                      },
                      child: Text('Save Changes'),
                    )
                  ],
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: appBgColor,
                appBar: AppBar(
                  backgroundColor: appBarColor,
                ),
                body: ListView(
                  children: [
                    Column(
                      children: [
                        Text('No messages yet'),
                      ],
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
