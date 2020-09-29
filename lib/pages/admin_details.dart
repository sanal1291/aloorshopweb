import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:freshgrownweb/services/admin_database_services.dart';
import 'package:freshgrownweb/shared/constants.dart';
import 'package:provider/provider.dart';

class AdminDetailsPage extends StatefulWidget {
  @override
  _AdminDetailsPageState createState() => _AdminDetailsPageState();
}

class _AdminDetailsPageState extends State<AdminDetailsPage> {
  AdminServices _adminServices = AdminServices();

  String _adminName;
  String _nextDeliveryTime;
  int fastDeliveryAmount;
  int freeFastDeliveryAmount;
  List<dynamic> locationMinAmount = [];
  List<String> areaNames = [];
  List<String> areaDropdownNames = [];
  bool databaseAdminDetailsLoaded = false;

  final _localityFormKey = GlobalKey<FormState>();
  final _areaFormKey = GlobalKey<FormState>();
  final _adminFormKey = GlobalKey<FormState>();

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
    User user = Provider.of<User>(context);
    return FocusWatcher(
      child: FutureBuilder<List<dynamic>>(
          future: futureFunction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!databaseAdminDetailsLoaded) {
                _adminName = snapshot.data[0].get('adminName');
                _nextDeliveryTime = snapshot.data[0].get('nextDeliveryTime');
                fastDeliveryAmount = snapshot.data[0].get('fastDeliveryAmount');
                freeFastDeliveryAmount =
                    snapshot.data[0].get('freeFastDeliveryAmount');
                // locationMinAmount = snapshot.data[0].get('locations');
                areaNames =
                    List<String>.from(snapshot.data[0].get('areaNames'));
                locationMinAmount = snapshot.data[1];
                databaseAdminDetailsLoaded = true;
              }
              return Scaffold(
                backgroundColor: appBgColor,
                appBar: AppBar(
                  backgroundColor: appBarColor,
                ),
                body: Form(
                  key: _adminFormKey,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _adminName,
                                    onChanged: (value) {
                                      _adminName = value;
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'Name', labelText: 'Name'),
                                    validator: (value) =>
                                        value.isEmpty ? "!" : null,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _nextDeliveryTime,
                                    onChanged: (value) {
                                      _nextDeliveryTime = value;
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'Next Delivery',
                                        labelText: 'Next Delivery Time'),
                                    validator: (value) =>
                                        value.isEmpty ? "!" : null,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: fastDeliveryAmount.toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        try {
                                          fastDeliveryAmount = int.parse(value);
                                        } catch (e) {
                                          print(e.toString());
                                          myToast("Please enter a number");
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      try {
                                        if (value.isEmpty) {
                                          return '!';
                                        } else if (!(fastDeliveryAmount
                                            is int)) {
                                          return 'Please enter a number';
                                        } else {
                                          return null;
                                        }
                                      } catch (e) {
                                        print(e.toString());
                                        return 'Something went wrong';
                                      }
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'Amount for fast delivery',
                                        labelText: 'Fast delivery amount'),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextFormField(
                                    initialValue:
                                        freeFastDeliveryAmount.toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        try {
                                          freeFastDeliveryAmount =
                                              int.parse(value);
                                        } catch (e) {
                                          print(e.toString());
                                          myToast("Please enter a number");
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      try {
                                        if (value.isEmpty) {
                                          return '!';
                                        } else if (!(freeFastDeliveryAmount
                                            is int)) {
                                          return 'Please enter a number';
                                        } else {
                                          return null;
                                        }
                                      } catch (e) {
                                        print(e.toString());
                                        return 'Something went wrong';
                                      }
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        hintText:
                                            'Amount for free fast delivery',
                                        labelText: 'Free fast delivery amount'),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Form(
                                  key: _areaFormKey,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            if (_areaFormKey.currentState
                                                .validate()) {
                                              setState(() {
                                                areaNames.add("");
                                              });
                                            }
                                          },
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          height: 600.0,
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: ListView(
                                            children: areaNames != null
                                                ? areaNames
                                                    .asMap()
                                                    .keys
                                                    .map((areaIndex) {
                                                    return SizedBox(
                                                      height: 80.0,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              initialValue:
                                                                  areaNames[
                                                                      areaIndex],
                                                              decoration: textInputDecoration
                                                                  .copyWith(
                                                                      hintText:
                                                                          'Area',
                                                                      labelText:
                                                                          'Area'),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  areaNames[
                                                                          areaIndex] =
                                                                      value;
                                                                });
                                                              },
                                                              validator:
                                                                  (value) {
                                                                return value
                                                                        .isEmpty
                                                                    ? '!'
                                                                    : null;
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.0),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList()
                                                : [],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Form(
                                  key: _localityFormKey,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            if (_localityFormKey.currentState
                                                .validate()) {
                                              setState(() {
                                                locationMinAmount.add({
                                                  'documentId': '',
                                                  'minAmount': 0
                                                });
                                              });
                                            }
                                          },
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          height: 600.0,
                                          child: ListView(
                                            children: locationMinAmount != null
                                                ? locationMinAmount
                                                    .map((arrayElement) {
                                                    return SizedBox(
                                                      height: 80.0,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                DropdownButtonFormField(
                                                              value:
                                                                  arrayElement[
                                                                      'area'],
                                                              onTap: () {
                                                                setState(() {
                                                                  areaDropdownNames =
                                                                      areaNames;
                                                                });
                                                              },
                                                              items: areaNames
                                                                  .map((area) {
                                                                return DropdownMenuItem(
                                                                  child: Text(
                                                                      area),
                                                                  value: area,
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                arrayElement[
                                                                        'area'] =
                                                                    value;
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.0),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              initialValue:
                                                                  arrayElement[
                                                                      'locality'],
                                                              decoration: textInputDecoration
                                                                  .copyWith(
                                                                      hintText:
                                                                          'Locality',
                                                                      labelText:
                                                                          'Locality'),
                                                              onChanged:
                                                                  (value) {
                                                                arrayElement[
                                                                        'locality'] =
                                                                    value;
                                                              },
                                                              validator:
                                                                  (value) {
                                                                return value
                                                                        .isEmpty
                                                                    ? '!'
                                                                    : null;
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.0),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              initialValue:
                                                                  arrayElement[
                                                                          'minAmount']
                                                                      .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  try {
                                                                    arrayElement[
                                                                            'minAmount'] =
                                                                        int.parse(
                                                                            value);
                                                                  } catch (e) {
                                                                    print(e
                                                                        .toString());
                                                                    myToast(
                                                                        "Please enter a number");
                                                                  }
                                                                });
                                                              },
                                                              validator:
                                                                  (value) {
                                                                try {
                                                                  if (value
                                                                      .isEmpty) {
                                                                    return 'Enter a Category priority';
                                                                  } else if (!(arrayElement[
                                                                          'minAmount']
                                                                      is int)) {
                                                                    return 'Please enter a number';
                                                                  } else {
                                                                    return null;
                                                                  }
                                                                } catch (e) {
                                                                  print(e
                                                                      .toString());
                                                                  return 'Something went wrong';
                                                                }
                                                              },
                                                              decoration: textInputDecoration
                                                                  .copyWith(
                                                                      hintText:
                                                                          'Min amount for free delivery',
                                                                      labelText:
                                                                          'Free delivery amount'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList()
                                                : [
                                                    Container(
                                                      height: 10.0,
                                                      width: 10.0,
                                                    )
                                                  ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        FlatButton(
                          color: appBarColor,
                          onPressed: () async {
                            if (_adminFormKey.currentState.validate() &&
                                _localityFormKey.currentState.validate() &&
                                _areaFormKey.currentState.validate()) {
                              bool result =
                                  await _adminServices.updateAdminDetails(
                                adminName: _adminName,
                                nextDeliveryTime: _nextDeliveryTime,
                                fastDeliveryAmount: fastDeliveryAmount,
                                freeFastDeliveryAmount: freeFastDeliveryAmount,
                                locations: locationMinAmount,
                                areaNames: areaNames,
                                uid: user.uid,
                              );
                              if (result) {
                                myToast('successfully saved');
                                Navigator.pop(context);
                              } else {
                                myToast('Something went wrong');
                              }
                            }
                          },
                          child: Text('Save changes'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                child: Text('loading'),
              );
            }
          }),
    );
  }
}
