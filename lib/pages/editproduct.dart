import 'dart:io';

import 'package:freshgrownweb/services/authservive.dart';
import 'package:freshgrownweb/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:freshgrownweb/models/category.dart';
import 'package:provider/provider.dart';
import 'package:freshgrownweb/services/addproductservice.dart';
import 'package:image_picker_web/image_picker_web.dart';
// import 'package:image_picker_for_web/image_picker_for_web.dart';

class EditProductClass {
  static List<Map<dynamic, dynamic>> data = [];
}

class EditProducts extends StatefulWidget {
  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  bool _isAddProduct = true;
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => EditProductClass(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isAddProduct = true;
            });
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Row(
            children: [
              Text("Edit page"),
              RaisedButton(
                onPressed: () {
                  AuthService().signOut();
                },
                child: Text('SignOUT'),
              )
            ],
          ),
        ),
        backgroundColor: Colors.green.shade100,
        body: ListView(
          children: [
            Row(children: [
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 50,
                  child: Center(child: Text("index"))),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 50,
                  child: Center(child: Text("rank"))),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 150,
                  child: Center(child: Text("name"))),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 150,
                  child: Center(child: Text("picture"))),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Center(child: Text("Varities")))),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 150,
                  child: Center(
                    child: Text("category"),
                  )),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 50,
                  child: Center(child: Text("actions"))),
            ]),
            _isAddProduct ? ItemRow() : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ItemRow extends StatefulWidget {
  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  Image _imageWidget;
  MediaInfo _imageFile;
  String _englishName;
  String _malayalamName;
  Map<String, dynamic> data;
  List<String> categories = [];
  List<Category> categoryList;

  final _formKeyProduct = GlobalKey<FormState>();
  final _formKeyVariety = GlobalKey<FormState>();
  List<Widget> varietyList = [VarietyWidget()];
  String networkImage;
  File fileImage;
  void addToVariety() {
    setState(() {
      varietyList.add(VarietyWidget());
    });
  }

  AddProductService newProductService = AddProductService();
  int _rank;

  @override
  Widget build(BuildContext context) {
    categoryList = Provider.of<List<Category>>(context) != null
        ? Provider.of<List<Category>>(context)
        : null;
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: IntrinsicHeight(
        child: Form(
          key: _formKeyProduct,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 50,
              ),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 50,
                  child: Center(
                      child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        try {
                          _rank = int.parse(value);
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
                        } else if (!(_rank is int)) {
                          return 'Please enter a number';
                        } else {
                          return null;
                        }
                      } catch (e) {
                        print(e.toString());
                        return 'Something went wrong';
                      }
                    },
                    decoration: textInputDecoration.copyWith(hintText: 'rank'),
                  ))),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 150,
                  height: 150,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          _englishName = value;
                        },
                        validator: (value) => value.isEmpty ? "!" : null,
                        decoration:
                            textInputDecoration.copyWith(hintText: "name(eng)"),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          _malayalamName = value;
                        },
                        validator: (value) => value.isEmpty ? "!" : null,
                        decoration:
                            textInputDecoration.copyWith(hintText: "name(mal)"),
                      ),
                    ],
                  )),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                width: 150,
                height: 100,
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_a_photo_sharp),
                      onPressed: () async {
                        var mediaData = await ImagePickerWeb.getImageInfo;
                        if (mediaData != null) {
                          setState(() {
                            _imageFile = mediaData;
                            _imageWidget = Image.memory(mediaData.data);
                          });
                        }
                      },
                    ),
                    _imageWidget != null
                        ? SizedBox(
                            height: 60,
                            child: Container(
                              child: _imageWidget,
                            ))
                        : Container()
                  ],
                ),
              ),
              Form(
                key: _formKeyVariety,
                child: Expanded(
                    child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Column(
                          children: [
                            ...varietyList,
                            IconButton(
                              icon: Icon(Icons.add_box),
                              onPressed: () {
                                if (_formKeyVariety.currentState.validate()) {
                                  addToVariety();
                                } else {
                                  myToast("these fields cant be empty");
                                }
                              },
                            )
                          ],
                        ))),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                width: 150,
                child: categoryList != null && categoryList.isNotEmpty
                    ? Column(
                        children: [
                          Wrap(
                            spacing: 10,
                            children: categories.map((e) => Text(e)).toList(),
                          ),
                          DropdownButtonFormField(
                            validator: (value) =>
                                categories.isEmpty ? "!" : null,
                            icon: Icon(Icons.arrow_downward),
                            items: categoryList
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      //todo
                                      child: Text(value.name),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (!(categories.contains(value.name))) {
                                setState(() {
                                  categories.add(value.name);
                                });
                              } else {
                                myToast("category already added");
                              }
                            },
                          ),
                        ],
                      )
                    : Container(),
              ),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 50,
                  child: IconButton(
                      icon: Icon(
                        Icons.add_rounded,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        if (_formKeyProduct.currentState.validate() &
                            _formKeyVariety.currentState.validate()) {
                          await newProductService.updateProductData(
                              varieties: EditProductClass.data,
                              displayNames: {
                                'en': _englishName,
                                'ml': _malayalamName
                              },
                              fileImage: _imageFile,
                              rank: _rank,
                              categories: categories);
                          print('successfully uploaded');
                          myToast("successfully uploaded");
                        } else {
                          myToast("fill all required fields");
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

class VarietyWidget extends StatefulWidget {
  @override
  _VarietyWidgetState createState() => _VarietyWidgetState();
}

class _VarietyWidgetState extends State<VarietyWidget> {
  List _temp;
  int _index;
  bool _isStock = true;

  @override
  void initState() {
    super.initState();
    _temp = EditProductClass.data;
    _temp.add({});
    this._index = _temp.length - 1;
    _temp[_index]['inStock'] = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                _temp[_index]['Variety'] = value;
              },
              validator: (value) => value.isEmpty ? "!" : null,
              decoration: textInputDecoration.copyWith(hintText: "Quality"),
            ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                _temp[_index]['unit'] = value;
              },
              validator: (value) => value.isEmpty ? "!" : null,
              decoration: textInputDecoration.copyWith(hintText: "unit"),
            ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                try {
                  _temp[_index]['tickQuantity'] = int.parse(value);
                } catch (e) {
                  print(e.toString());
                  myToast("Please enter a number");
                }
              },
              validator: (value) {
                try {
                  if (value.isEmpty) {
                    return 'Enter a Category priority';
                  } else if (!(_temp[_index]['tickQuantity'] is int)) {
                    return 'Please enter a number';
                  } else {
                    return null;
                  }
                } catch (e) {
                  print(e.toString());
                  return 'Something went wrong';
                }
              },
              decoration:
                  textInputDecoration.copyWith(hintText: "Min quantity"),
            ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                try {
                  _temp[_index]['price'] = double.parse(value);
                } catch (e) {
                  print(e.toString());
                  myToast("Please enter a number");
                }
              },
              validator: (value) {
                try {
                  if (value.isEmpty) {
                    return 'Enter a Category priority';
                  } else if (!(_temp[_index]['tickQuantity'] is double)) {
                    return 'Please enter a number';
                  } else {
                    return null;
                  }
                } catch (e) {
                  print(e.toString());
                  return 'Something went wrong';
                }
              },
              decoration: textInputDecoration.copyWith(hintText: "price"),
            ),
          ),
          Checkbox(
            value: _isStock,
            onChanged: (value) {
              setState(() {
                _isStock = !_isStock;
                _temp[_index]['inStock'] = _isStock;
              });
            },
          ),
        ],
      ),
    );
  }
}
