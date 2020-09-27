import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:freshgrownweb/shared/constants.dart';

class AdminDetailsPage extends StatefulWidget {
  @override
  _AdminDetailsPageState createState() => _AdminDetailsPageState();
}

class _AdminDetailsPageState extends State<AdminDetailsPage> {
  int minAmount;
  List<Map> locationMinAmount = [];
  List<String> areaNames = [];
  List<String> areaDropdownNames = [];

  final _localityFormKey = GlobalKey<FormState>();
  final _areaFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        backgroundColor: appBgColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
        ),
        body: Form(
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
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Name', labelText: 'Name'),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Next Delivery',
                                labelText: 'Next Delivery Time'),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                try {
                                  minAmount = int.parse(value);
                                } catch (e) {
                                  print(e.toString());
                                  myToast("Please enter a number");
                                }
                              });
                            },
                            validator: (value) {
                              try {
                                if (value.isEmpty) {
                                  return 'Enter a Category priority';
                                } else if (!(minAmount is int)) {
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
                            onChanged: (value) {
                              setState(() {
                                try {
                                  minAmount = int.parse(value);
                                } catch (e) {
                                  print(e.toString());
                                  myToast("Please enter a number");
                                }
                              });
                            },
                            validator: (value) {
                              try {
                                if (value.isEmpty) {
                                  return 'Enter a Category priority';
                                } else if (!(minAmount is int)) {
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
                                hintText: 'Amount for free fast delivery',
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
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (_areaFormKey.currentState.validate()) {
                                      setState(() {
                                        areaNames.add("");
                                      });
                                    }
                                  },
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  height: 600.0,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                                    child: TextFormField(
                                                      decoration:
                                                          textInputDecoration
                                                              .copyWith(
                                                                  hintText:
                                                                      'Area',
                                                                  labelText:
                                                                      'Area'),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          areaNames[areaIndex] =
                                                              value;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        return value.isEmpty
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
                        Form(
                          key: _localityFormKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (_localityFormKey.currentState
                                        .validate()) {
                                      setState(() {
                                        locationMinAmount.add(Map());
                                      });
                                    }
                                  },
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: 600.0,
                                  child: ListView(
                                    children: locationMinAmount != null
                                        ? locationMinAmount.map((arrayElement) {
                                            return SizedBox(
                                              height: 80.0,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        DropdownButtonFormField(
                                                      onTap: () {
                                                        setState(() {
                                                          areaDropdownNames =
                                                              areaNames;
                                                        });
                                                      },
                                                      items:
                                                          areaNames.map((area) {
                                                        return DropdownMenuItem(
                                                          child: Text(area),
                                                          value: area,
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        arrayElement[
                                                            'locality'] = value;
                                                      },
                                                    ),
                                                    // TextFormField(
                                                    //   decoration:
                                                    //       textInputDecoration
                                                    //           .copyWith(
                                                    //               hintText:
                                                    //                   'Area',
                                                    //               labelText:
                                                    //                   'Area'),
                                                    //   onChanged: (value) {
                                                    //     arrayElement[
                                                    //         'locality'] = value;
                                                    //   },
                                                    //   validator: (value) {
                                                    //     return value.isEmpty
                                                    //         ? '!'
                                                    //         : null;
                                                    //   },
                                                    // ),
                                                  ),
                                                  SizedBox(width: 10.0),
                                                  Expanded(
                                                    child: TextFormField(
                                                      decoration:
                                                          textInputDecoration
                                                              .copyWith(
                                                                  hintText:
                                                                      'Locality',
                                                                  labelText:
                                                                      'Locality'),
                                                      onChanged: (value) {
                                                        arrayElement[
                                                            'locality'] = value;
                                                      },
                                                      validator: (value) {
                                                        return value.isEmpty
                                                            ? '!'
                                                            : null;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.0),
                                                  Expanded(
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          try {
                                                            arrayElement[
                                                                    'minAmount'] =
                                                                int.parse(
                                                                    value);
                                                          } catch (e) {
                                                            print(e.toString());
                                                            myToast(
                                                                "Please enter a number");
                                                          }
                                                        });
                                                      },
                                                      validator: (value) {
                                                        try {
                                                          if (value.isEmpty) {
                                                            return 'Enter a Category priority';
                                                          } else if (!(arrayElement[
                                                                  'minAmount']
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
