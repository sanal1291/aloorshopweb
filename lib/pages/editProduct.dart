import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/database.dart';

class EditItem extends StatefulWidget {
  EditItem({Key key}) : super(key: key);

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditItem> {
  List<Widget> varietyColumn(List<dynamic> varities) {
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
        ],
      ));
    }
    return varietyList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
        stream: DatabaseService().getItems,
        builder: (context, snapshot) {
          List<Item> items = snapshot.data;
          return Scaffold(
              appBar: AppBar(
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
                                children: varietyColumn(items[index].varieties),
                              ),
                              RaisedButton(
                                onPressed: () {},
                                child: Icon(Icons.edit),
                              ),
                              RaisedButton(
                                onPressed: () {},
                                child: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container());
        });
  }
}
