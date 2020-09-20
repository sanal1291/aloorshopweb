import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshgrownweb/models/cart_item.dart';
import 'package:freshgrownweb/models/item.dart';
import 'package:freshgrownweb/models/category.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final firestoreInstance = FirebaseFirestore.instance;
  final users = FirebaseFirestore.instance.collection("users");
  final categories = FirebaseFirestore.instance.collection("Categories");
  final items = FirebaseFirestore.instance.collection("items");

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
    return items.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Item(
            uid: doc.id,
            name: doc.get('name'),
            picture: doc.get('image'),
            category: doc.get('category'),
            searchArray: doc.get('searchArray'),
            price: doc.get('price')))
        .toList());
  }

// get similar products as category
  Stream<List<Item>> getSimilarItems(category) {
    return items
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Item(
                  uid: doc.id,
                  name: doc.get('name'),
                  picture: doc.get('image'),
                  price: doc.get('price'),
                  category: doc.get('category'),
                ))
            .toList());
  }

  // add to cart
  Future updateCart(
      {Item item, num quantity, String quality, num total}) async {
    try {
      return await users.doc(uid).collection("cart").doc().set({
        "itemId": item.uid,
        "name": item.name,
        "picture": item.picture,
        "quality": quality,
        "quantity": quantity,
        "total": total,
      });
    } catch (e) {
      print(e.toString());
    }
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
}
