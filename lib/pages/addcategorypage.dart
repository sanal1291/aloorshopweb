import 'package:flutter/material.dart';
import 'package:freshgrownweb/shared/constants.dart';
import 'package:image_picker_web/image_picker_web.dart';
import "package:freshgrownweb/services/addproductservice.dart";

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _categoryFormKey = GlobalKey<FormState>();

  String _catName;
  String _catNameMal;
  Image _imageWidget;
  MediaInfo _imageFile;
  AddProductService newProductService = AddProductService();
  int categoryPriority;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
      ),
      body: Form(
        key: _categoryFormKey,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
          child: ListView(
            children: [
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    hintText: 'Category Name', labelText: 'Category Name'),
                onChanged: (value) {
                  _catName = value;
                },
                validator: (value) => value.isEmpty ? "!" : null,
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    hintText: 'Category Name(Mal)',
                    labelText: 'Category Name(Mal)'),
                onChanged: (value) {
                  _catNameMal = value;
                },
                validator: (value) => value.isEmpty ? "!" : null,
              ),
              SizedBox(height: 10.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    try {
                      categoryPriority = int.parse(value);
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
                    } else if (!(categoryPriority is int)) {
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
                    hintText: 'Priority', labelText: 'Priority'),
              ),
              SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                height: 500,
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
                            height: 400,
                            child: Container(
                              child: _imageWidget,
                            ))
                        : Container()
                  ],
                ),
              ),
              FlatButton(
                color: appBarColor,
                onPressed: () async {
                  if (_categoryFormKey.currentState.validate() &&
                      (_imageWidget != null)) {
                    dynamic result = await newProductService.addCategory(
                        category: {'en': _catName, 'ml': _catNameMal},
                        fileImage: _imageFile,
                        priority: categoryPriority);
                    print(result);
                  }
                },
                child: Text('Add Category'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
