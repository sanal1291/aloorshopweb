import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshgrownweb/models/cart_item.dart';
import 'package:freshgrownweb/models/indipendentItem.dart';
import 'package:freshgrownweb/models/item.dart';
import 'package:freshgrownweb/models/category.dart';
import 'package:freshgrownweb/models/package.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final firestoreInstance = FirebaseFirestore.instance;
  final users = FirebaseFirestore.instance.collection("users");
  final categories = FirebaseFirestore.instance.collection("Categories");
  final items = FirebaseFirestore.instance.collection("items");
  final packages = FirebaseFirestore.instance.collection("packages");
  final independentItems =
      FirebaseFirestore.instance.collection("independentItems");

// update the user data in firestore
  Future updateUserData(
      {String fullname, String email, String address, String pincode}) async {
    try {
      return await users.doc(uid).set({
        'fullname': fullname,
        'email': email,
        'address': address,
        'pincode': pincode
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // get category list
  Stream<List<Category>> get getCategories {
    return categories.snapshots().map((snapshot) => snapshot.docs
        .map(
          (doc) => Category(
            name: doc.get('name'),
            displayNames: doc.get('displayNames'),
            image: doc.get('imageUrl'),
            searchArray: doc.get('searchArray'),
            priority: doc.get('priority'),
          ),
        )
        .toList());
  }

// get item list as stream
  Stream<List<Item>> get getItems {
    return items.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Item(
                uid: doc.id,
                rank: doc.data()['rank'],
                name: doc.data()['name'],
                displayNames: doc.data()['displayName'],
                imageUrl: doc.data()['imageUrl'],
                categories: doc.data()['category'],
                searchArray: doc.data()['searchArray'],
                varieties: doc.data()['varieties'],
                inStock: doc.data()['inStock'],
              ))
          .toList();
    });
  }

  // get independent items as stream
  Stream<List<IndiItem>> get getIndiItems {
    return independentItems.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => IndiItem(
                uid: doc.id,
                rank: doc.data()['rank'],
                name: doc.data()['name'],
                categories: doc.data()['category'],
                inStock: doc.data()['inStock'],
                image: doc.data()['image'],
                unit: doc.data()['unit'],
                price: doc.data()['price'],
                tick: doc.data()['tick'],
              ))
          .toList();
    });
  }

  Future<List<IndiItem>> getIndiItem() {
    var snapshot = independentItems.get();
    return snapshot.then((value) => value.docs
        .map((e) => IndiItem(
              uid: e.id,
              rank: e.data()['rank'],
              name: e.data()['name'],
              categories: e.data()['category'],
              inStock: e.data()['inStock'],
              image: e.data()['image'],
              unit: e.data()['unit'],
              price: e.data()['price'],
              tick: e.data()['tick'],
            ))
        .toList());
  }

  // get cart list as stream
  Stream<List<CartItem>> get getCart {
    return users
        .doc(uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => CartItem(
                itemId: doc.get('itemId'),
                name: doc.get('name'),
                picture: doc.get('picture'),
                quality: doc.get('quality'),
                quantity: doc.get('quantity'),
                total: doc.get('total'),
              ),
            )
            .toList());
  }

  // get packages as future
  Future<List<Package>> getPackages() async {
    var snapshot = packages.get();
    return snapshot.then((value) => value.docs
        .map((e) => Package(
              imageUrl: e.get('image'),
              name: e.get('name'),
              items: e.get('items'),
              price: e.get('price'),
              uid: e.id,
            ))
        .toList());
  }
}
