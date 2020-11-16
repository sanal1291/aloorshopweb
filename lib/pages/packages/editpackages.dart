import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:freshgrownweb/models/indipendentItem.dart';
import 'package:freshgrownweb/models/package.dart';
import 'package:freshgrownweb/services/addpackage.dart';
import 'package:freshgrownweb/shared/constants.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';

class EditPackage extends StatefulWidget {
  final Package package;
  EditPackage({this.package});
  @override
  EeditPackageState createState() => EeditPackageState();
}

class EeditPackageState extends State<EditPackage> {
  AddPackageService packageService = AddPackageService();
  final _formKeyPackage = GlobalKey<FormState>();
  MediaInfo _imageFile;
  Image _imageWidget;
  bool _isLoading = false;
  bool edit;
  List<IndiItem> _indiItems = [], allIndiItems;
  String _name;
  int _calculatedPrice;
  int _specialPrice;
  @override
  void initState() {
    edit = widget.package == null ? false : true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allIndiItems = Provider.of<List<IndiItem>>(context) != null
        ? Provider.of<List<IndiItem>>(context)
        : [];
    IndiItem item;
    if (edit && _indiItems.isEmpty) {
      _name = widget.package.name;
      if (allIndiItems != null && widget.package.items != null) {
        // getting indipendent items form package List<dynamic>
        for (var i = 0; i < widget.package.items.length; i++) {
          item = allIndiItems.singleWhere(
              (element) => element.uid == widget.package.items[i]['item']);
          item.quantity = widget.package.items[i]['quantity'];
          _indiItems.add(item);
        }
      }
    }
    _calculatedPrice = 0;
    _indiItems.isEmpty
        ? 0
        : _indiItems.forEach((element) {
            _calculatedPrice +=
                element.price != null && element.quantity != null
                    ? (element.price * element.quantity)
                    : 0;
          });

    return FocusWatcher(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
              title: Text(
                  edit ? 'Edit ${widget.package.name}' : 'Create new package'),
            ),
            body: Stack(
              children: [
                Container(
                  color: appBgColor,
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Column(
                    children: [
                      Expanded(
                          child: Form(
                        key: _formKeyPackage,
                        child: ListView(
                          children: [
                            Wrap(
                              spacing: 20,
                              direction: Axis.horizontal,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 600),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Text(
                                                'Name of Package:',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              width: double.infinity,
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                            ),
                                            TextFormField(
                                              initialValue: edit
                                                  ? widget.package.name
                                                  : '',
                                              decoration: textBlueInputDecoration
                                                  .copyWith(
                                                      hintText:
                                                          "Name of package"),
                                              onChanged: (value) {
                                                _name = value;
                                              },
                                              validator: (value) {
                                                try {
                                                  if (value.isEmpty ||
                                                      value is int) {
                                                    return "Enter a valid package name";
                                                  } else
                                                    return null;
                                                } catch (e) {
                                                  return "something went wrong";
                                                }
                                              },
                                            ),
                                            Container(
                                              child: Text(
                                                'Price:',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              width: double.infinity,
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 5),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child:
                                                        Text('Total price:')),
                                                Expanded(
                                                  child: Text(
                                                      _calculatedPrice == null
                                                          ? '0'
                                                          : _calculatedPrice
                                                              .toString()),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Enter price:',
                                                    )),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    initialValue: edit
                                                        ? widget.package.name
                                                        : '',
                                                    decoration:
                                                        textBlueInputDecoration
                                                            .copyWith(
                                                                hintText:
                                                                    "Special price"),
                                                    onChanged: (value) {
                                                      _specialPrice =
                                                          int.tryParse(value);
                                                    },
                                                    validator: (value) {
                                                      if (int.tryParse(value) !=
                                                              null &&
                                                          value.isNotEmpty) {
                                                        return null;
                                                      } else {
                                                        return "Enter a valid price";
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // image input field
                                FormField(
                                  validator: (value) {
                                    if (!edit && _imageFile == null)
                                      return 'select an image';
                                    return null;
                                  },
                                  builder: (FormFieldState<int> state) =>
                                      Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.green[200],
                                            width: 3)),
                                    constraints: BoxConstraints(maxWidth: 200),
                                    child: Column(
                                      children: [
                                        Text("Package image:"),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: InkWell(
                                              child: _imageWidget == null
                                                  ? edit
                                                      ? Image.network(widget
                                                              .package
                                                              .imageUrl ??
                                                          '')
                                                      : Center(
                                                          child: Text(
                                                            'Click to select image',
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                        )
                                                  : _imageWidget,
                                              onTap: () async {
                                                var mediaData =
                                                    await ImagePickerWeb
                                                        .getImageInfo;
                                                if (mediaData != null) {
                                                  setState(() {
                                                    _imageFile = mediaData;
                                                    _imageWidget = Image.memory(
                                                        mediaData.data);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        state.hasError
                                            ? Center(
                                                child: Text(
                                                  state.errorText,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Center(
                                child: Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Add items to package",
                                style: TextStyle(fontSize: 16),
                              ),
                            )),
                            Container(
                              height: 600,
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    decoration: windowDecoration,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: FormField(
                                      validator: (value) => _indiItems.isEmpty
                                          ? 'Empty items'
                                          : null,
                                      builder: (FormFieldState<int> state) =>
                                          _indiItems.isEmpty
                                              ? Container(
                                                  height: 600,
                                                  child: Text(
                                                    'Select atleast 1 item',
                                                    textAlign: TextAlign.center,
                                                    style: state.hasError
                                                        ? TextStyle(
                                                            color: Colors.red,
                                                            letterSpacing: 2.0)
                                                        : TextStyle(),
                                                  ),
                                                )
                                              : Scrollbar(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            6, 4, 8, 4),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                'Name',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                'Price',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                'Quantity',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            FlatButton(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color:
                                                              Colors.green[500],
                                                          thickness: 1,
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                              itemCount:
                                                                  _indiItems
                                                                      .length,
                                                              itemBuilder: (context,
                                                                      index) =>
                                                                  oneIndiItem(
                                                                      _indiItems[
                                                                          index])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                    ),
                                  )),
                                  VerticalDivider(
                                    indent: 20,
                                    endIndent: 20,
                                    color: Colors.green[200],
                                    thickness: 10,
                                    width: 40,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: windowDecoration,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Scrollbar(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(6, 4, 8, 4),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      'Name',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Unit',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Price',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.green[500],
                                                thickness: 1,
                                              ),
                                              allIndiItems.isNotEmpty
                                                  ? Expanded(
                                                      child: ListView.builder(
                                                        itemBuilder: (context,
                                                                index) =>
                                                            oneAllIndiItems(
                                                                allIndiItems[
                                                                    index]),
                                                        itemCount:
                                                            allIndiItems.length,
                                                      ),
                                                    )
                                                  : Column(
                                                      children: [
                                                        Text('loading')
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                      Container(
                        width: 300,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            !_isLoading
                                ? RaisedButton(
                                    child: Text('Save'),
                                    onPressed: () async {
                                      setState(() {
                                        // _isLoading = true;
                                      });
                                      if (_formKeyPackage.currentState
                                          .validate()) {
                                        // return null;
                                        String uid =
                                            edit ? widget.package.uid : null;
                                        bool status =
                                            await packageService.addPackage(
                                          uid: uid,
                                          name: _name,
                                          items: _indiItems,
                                          fileInfo: _imageFile,
                                          imageUrl: edit
                                              ? (widget.package.imageUrl != null
                                                  ? widget.package.imageUrl
                                                  : '')
                                              : '',
                                          price: _specialPrice,
                                          total: _calculatedPrice,
                                        );
                                        if (status) {
                                          Navigator.pushReplacementNamed(
                                              context, '/packages');
                                        }
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                  )
                                : RaisedButton(
                                    onPressed: () {},
                                    child: Text('processing'),
                                  ),
                            RaisedButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget oneIndiItem(IndiItem e) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Row(
        key: ValueKey(e.uid),
        children: [
          Expanded(
            flex: 3,
            child: Text(e.name),
          ),
          Expanded(flex: 2, child: Text(e.price.toString())),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  height: 50,
                  child: TextFormField(
                    initialValue: e.quantity.toString(),
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isNotEmpty &&
                          int.tryParse(value) is int &&
                          int.parse(value) > 0) {
                        e.quantity = int.parse(value);
                        return null;
                      } else {
                        e.quantity = 0;
                        if (int.tryParse(value) == null ||
                            int.tryParse(value) < 1) {
                          return "Enter a appropriate quantity";
                        } else
                          return 'something went wrong';
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        e.quantity = int.tryParse(value);
                      });
                    },
                  ),
                  // ),
                  width: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("${e.unit} units"),
                )
              ],
            ),
          ),
          RaisedButton(
            child: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _indiItems.removeWhere((element) => element.uid == e.uid);
              });
            },
          )
        ],
      ),
    );
  }

  Widget oneAllIndiItems(IndiItem e) {
    bool contains = _indiItems.contains(e) ?? false;
    return Container(
      color: contains ? Colors.grey : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 3, child: Text(e.name)),
            Expanded(
              flex: 2,
              child: Text(
                e.unit ?? "NA",
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(flex: 2, child: Text(e.price.toString())),
            RaisedButton(
              child: Icon(contains ? Icons.remove : Icons.add),
              onPressed: () {
                if (contains) {
                  setState(() {
                    _indiItems.removeWhere((element) => element.uid == e.uid);
                  });
                } else {
                  setState(() {
                    _indiItems.add(e);
                    _indiItems
                        .singleWhere((element) => element.uid == e.uid)
                        .quantity = 1;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

final windowDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border.all(color: Colors.green, width: 3));
