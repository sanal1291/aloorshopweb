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
  int _price;
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

    return FocusWatcher(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
            ),
            body: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                          child: Center(
                              child: Text(edit
                                  ? 'Edit ${widget.package.name}'
                                  : 'Create new package'))),
                      Expanded(
                          child: Form(
                        key: _formKeyPackage,
                        child: ListView(
                          children: [
                            Wrap(
                              spacing: 20,
                              direction: Axis.horizontal,
                              children: [
                                Container(
                                  height: 100,
                                  color: Colors.blue,
                                  constraints: BoxConstraints(maxWidth: 500),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Text('Name of Package:'),
                                          width: double.infinity,
                                        ),
                                        TextFormField(
                                          initialValue:
                                              edit ? widget.package.name : '',
                                          decoration:
                                              textBlueInputDecoration.copyWith(
                                                  hintText: "Name of package"),
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
                                      ],
                                    ),
                                  ),
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
                                    color: Colors.green,
                                    constraints: BoxConstraints(maxWidth: 200),
                                    child: Column(
                                      children: [
                                        Text("Package image:"),
                                        Expanded(
                                          child: InkWell(
                                            child: _imageWidget == null
                                                ? edit
                                                    ? Image.network(widget
                                                            .package.imageUrl ??
                                                        '')
                                                    : Center(
                                                        child: Text(
                                                            'Click to select image'),
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
                            Container(
                              height: 900,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8.0, 5, 8, 0),
                                    child: FormField(
                                      validator: (value) => _indiItems.isEmpty
                                          ? 'Empty items'
                                          : null,
                                      builder: (FormFieldState<int> state) =>
                                          Container(
                                        color: Colors.cyan,
                                        child: _indiItems.isEmpty
                                            ? Container(
                                                height: 900,
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
                                            : ListView.builder(
                                                itemCount: _indiItems.length,
                                                itemBuilder: (context, index) =>
                                                    oneIndiItem(
                                                        _indiItems[index])),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 5, 8, 0),
                                      child: Container(
                                          color: Colors.green,
                                          child: ListView.builder(
                                            itemBuilder: (context, index) =>
                                                oneAllIndiItems(
                                                    allIndiItems[index]),
                                            itemCount: allIndiItems.length,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                      Container(
                          child: !_isLoading
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
                                  child: Text('processing'),
                                ))
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget oneIndiItem(IndiItem e) {
    TextEditingController _controller = TextEditingController();
    // _controller.text = e.quantity.toString() ?? '1';
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(e.name),
          ),
          Row(
            children: [
              Container(
                child: TextFormField(
                  initialValue: e.quantity.toString(),
                  textAlign: TextAlign.center,
                  // controller: _controller,
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
                        return "Enter a appropriate quntity";
                      } else
                        return 'something went wrong';
                    }
                  },
                ),
                width: 50,
              ),
              RaisedButton(
                child: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _indiItems.removeWhere((element) => element.uid == e.uid);
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget oneAllIndiItems(IndiItem e) {
    return Container(
      color: _indiItems.contains(e) ?? false ? Colors.grey : Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(e.name)),
          Row(
            children: [
              RaisedButton(
                child: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _indiItems.add(e);
                    _indiItems
                        .singleWhere((element) => element.uid == e.uid)
                        .quantity = 1;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
