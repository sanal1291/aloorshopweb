import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshgrownweb/models/item.dart';
import 'package:freshgrownweb/services/editproductservice.dart';
import 'package:freshgrownweb/shared/constants.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';

class EditSingleItem extends StatelessWidget {
  final Item item;
  EditSingleItem({this.item});
  @override
  Widget build(BuildContext context) {
    return Provider<Item>.value(
        value: item,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
          ),
          backgroundColor: appBgColor,
          body: Test(),
        ));
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  EditProductService editProductService = EditProductService();
  Image _imageWidget;
  MediaInfo _imageFile;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(
                      text:
                          '${Provider.of<Item>(context, listen: false).rank}'),
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Rank', labelText: 'Rank'),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    try {
                      Provider.of<Item>(context, listen: false).rank =
                          int.parse(value);
                    } catch (e) {
                      print(e.toString());
                      myToast("Please enter a number");
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: TextEditingController(
                          text:
                              '${Provider.of<Item>(context, listen: false).displayNames['ml']}'),
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Mal Name', labelText: 'Mal Name'),
                      onChanged: (value) {
                        try {
                          Provider.of<Item>(context, listen: false)
                              .displayNames['ml'] = value;
                        } catch (e) {
                          print(e.toString());
                          myToast("Something went wrong");
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: TextEditingController(
                          text:
                              '${Provider.of<Item>(context, listen: false).displayNames['en']}'),
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Eng Name', labelText: 'Eng Name'),
                      onChanged: (value) {
                        try {
                          Provider.of<Item>(context, listen: false)
                              .displayNames['en'] = value;
                        } catch (e) {
                          print(e.toString());
                          myToast("Something went wrong");
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: 20.0,
                child: Checkbox(
                  value: Provider.of<Item>(context, listen: false).inStock,
                  onChanged: (value) {
                    try {
                      setState(() {
                        Provider.of<Item>(context, listen: false).inStock =
                            value;
                      });
                    } catch (e) {
                      print(e.toString());
                      myToast("Something went wrong");
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
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
              : Container(),
          ...Provider.of<Item>(context, listen: false)
              .varieties
              .map((variety) => Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: TextEditingController(
                                text: '${variety['variety']}'),
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Name', labelText: 'Name'),
                            onChanged: (value) {
                              try {
                                variety['variety'] = value;
                              } catch (e) {
                                print(e.toString());
                                myToast("Something went wrong");
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        SizedBox(
                          width: 20.0,
                          child: Checkbox(
                            value: variety['inStock'],
                            onChanged: (value) {
                              try {
                                setState(() {
                                  variety['inStock'] = value;
                                });
                              } catch (e) {
                                print(e.toString());
                                myToast("Something went wrong");
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ))
              .toList(),
          SizedBox(
            height: 10.0,
          ),
          FlatButton(
            color: appBarColor,
            child: Text('Save'),
            onPressed: () {
              print(Provider.of<Item>(context, listen: false)
                  .varieties
                  .map((e) => e['variety']));
              editProductService.editProductData(
                  item: Provider.of<Item>(context, listen: false),
                  fileImage: _imageFile);
            },
          ),
        ],
      ),
    );
  }
}
