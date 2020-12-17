import 'package:flutter/material.dart';
import 'package:freshgrownweb/shared/constants.dart';

import '../models/item.dart';
import '../services/database.dart';

class EditItem extends StatefulWidget {
  EditItem({Key key}) : super(key: key);

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditItem> {
  // bool saveFlag = false;

  List<Widget> varietyColumn(List<dynamic> varities, int index) {
    List<Widget> varietyList = [];
    for (var variety in varities) {
      varietyList.add(Row(
        children: [
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("variety: ${variety['variety']}"),
          )),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("stock: ${variety['inStock']}"),
          )),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("price: ${variety['price']}"),
          )),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("tick :${variety['tickQuantity']}"),
          )),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("unit :${variety['unit']}"),
          )),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Checkbox(
              value: variety['inStock'],
              onChanged: (bool value) {
                // setState(() {
                //   variety['inStock'] = value;
                //   // saveFlag = true;
                // });
              },
            ),
          )),
        ],
      ));
    }
    // if (saveFlag) {
    //   varietyList.add(Row(
    //     children: [
    //       FlatButton(
    //         color: appBarColor,
    //         onPressed: () async {},
    //         child: Text('Save'),
    //       )
    //     ],
    //   ));
    // }
    return varietyList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
        stream: DatabaseService().getItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Item> items = snapshot.data;
            items.sort((a, b) => (a.name).compareTo(b.name));
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: appBarColor,
                  title: Text("Edit Page"),
                ),
                body: snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text((index + 1).toString()),
                                Text(items[index].name),
                                Text(items[index].displayNames['ml']),
                                Image.network(
                                  items[index].imageUrl,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                                Text(items[index].inStock.toString()),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: varietyColumn(
                                      items[index].varieties, index),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        '/edit single item',
                                        arguments: items[index]);
                                  },
                                  child: Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container());
          } else {
            return Container();
          }
        });
  }
}
