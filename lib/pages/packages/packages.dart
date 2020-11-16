import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:freshgrownweb/models/indipendentItem.dart';
import 'package:freshgrownweb/models/package.dart';
import 'package:freshgrownweb/services/database.dart';
import 'package:freshgrownweb/shared/constants.dart';
import 'package:provider/provider.dart';

class Packages extends StatefulWidget {
  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  DatabaseService _databaseService = DatabaseService();
  List<Package> packages = [];
  Package selected;
  List<IndiItem> items;
  List<IndiItem> packageItems;

  Future<List<Package>> getPackages() async {
    packages = await _databaseService.getPackages();
    return packages;
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
        child: FutureBuilder<List<Package>>(
      future: getPackages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              backgroundColor: appBgColor,
              appBar: AppBar(
                backgroundColor: appBarColor,
                title: Center(child: Text("Packages")),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child: Text(
                                        "Packages",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600),
                                      ))),
                                      RaisedButton(
                                        child: Text(
                                          'Add New pakage',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            '/edit packages',
                                          );
                                        },
                                      ),
                                      SizedBox(width: 5),
                                      RaisedButton(
                                        child: Text('Edit selected',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        onPressed: selected == null
                                            ? null
                                            : () {
                                                Navigator.of(context).pushNamed(
                                                    '/edit packages',
                                                    arguments: selected);
                                              },
                                      )
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'Name',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    Expanded(
                                        child: Text(
                                      'No of items',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    Expanded(
                                        child: Text(
                                      'Selling Price',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    Expanded(
                                        child: Text(
                                      'Total Price',
                                      style: TextStyle(fontSize: 20),
                                    ))
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                Expanded(
                                  child: ListView(
                                    children: packages
                                        .map((e) => packageTile(e))
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.green,
                            thickness: 1,
                            indent: 40,
                            endIndent: 20,
                          ),
                          Expanded(
                              child: Column(
                            children: [
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Package details',
                                  style: TextStyle(fontSize: 20),
                                ),
                              )),
                              Expanded(
                                child: detailsPane(),
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        } else {
          return Container(child: Text('Loading'));
        }
      },
    ));
  }

  Widget packageTile(e) {
    return Container(
      decoration: BoxDecoration(
          color: (selected != null ? selected.uid : null) == e.uid
              ? Colors.grey[500]
              : null,
          border: Border(bottom: BorderSide(color: Colors.green[400]))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selected = e;
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(e.name, style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    child: Text(e.items.length.toString()),
                  ),
                  Expanded(
                    child: Text(e.price.toString()),
                  ),
                  Expanded(
                    child: Text(e.total.toString()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget indiItemTile(e) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.green[300]))),
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              e.name,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(e.quantity.toString()),
          ),
          Expanded(
            child: Text(e.price.toString()),
          ),
          Expanded(
            child: Text(e.unit ?? "NA"),
          ),
        ],
      ),
    );
  }

  Widget detailsPane() {
    if (selected == null) {
      // if no package is selected
      return selected == null
          ? Container(
              child: Center(
                  child: Text(
              'Select a package to show details',
              style: TextStyle(fontStyle: FontStyle.italic),
            )))
          : Container(color: Colors.blue);
    } else {
      // if a package is clicked
      packageItems = [];
      IndiItem item;
      items = Provider.of<List<IndiItem>>(context);
      if (items != null) {
        for (var i = 0; i < selected.items.length; i++) {
          item = items.singleWhere(
              (element) => element.uid == selected.items[i]['item']);
          item.quantity = selected.items[i]['quantity'];
          packageItems.add(item);
        }
      }
      return items == null
          ? Center(
              child: Text('Loading...'),
            )
          : Scrollbar(
              child: ListView(children: [
                Container(
                    child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Center(child: Text('Image')),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Image.network(selected.imageUrl),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Center(
                        child: Text('Package details'),
                      ),
                    ),
                  ),
                ])),
                Divider(
                  color: Colors.green,
                  thickness: 2,
                  indent: 40,
                  endIndent: 40,
                ),
                Center(
                    child: Text(
                  'Package items',
                  style: TextStyle(fontSize: 15),
                )),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Name',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Quantity',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Price',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Unit',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.green[500],
                  thickness: 1,
                ),
                Column(
                  children: packageItems.map((e) => indiItemTile(e)).toList(),
                )
              ]),
            );
    }
  }
}
