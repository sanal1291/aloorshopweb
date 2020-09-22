import 'dart:io';
import 'package:firebase/firebase.dart' as fb;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshgrownweb/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

class AddProductService {
  final items = FirebaseFirestore.instance.collection("items");
  final categories = FirebaseFirestore.instance.collection("Categories");
  final storage = FirebaseStorage.instance;
  final independentItems =
      FirebaseFirestore.instance.collection("independentItems");

  // add the product details to firestore and image to firestorage

  Future updateProductData(
      {List<Map> varieties,
      MediaInfo fileImage,
      List<String> categories,
      num rank,
      Map displayNames}) async {
    List<String> searchArray = [];
    for (String productName in displayNames.values) {
      for (var i = 0; i < productName.length; i++) {
        searchArray.add(productName.substring(0, i + 1));
      }
    }
    try {
      String mimeType = mime(basename(fileImage.fileName));
      var metaData = fb.UploadMetadata(contentType: mimeType);
      fb.StorageReference _storage =
          fb.storage().ref('product_images/${fileImage.fileName}');
      fb.UploadTaskSnapshot uploadTaskSnapshot =
          await _storage.put(fileImage.data, metaData).future;
      var imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      String url = imageUri.toString();
      for (Map e in varieties) {
        DocumentReference docRef = independentItems.doc();
        docRef.set({
          'rank': rank,
          'name': displayNames['en'],
          'displayName': displayNames,
          'imageUrl': url,
          'category': categories,
          'quality': e['quality'],
          'unitMeasured': e['unit'],
          'price': e['price'],
          'tikcQuantity': e['tickQuantity'],
          'inStock': e['inStock'],
        });
        print(docRef.id);
        e['itemId'] = docRef.id;
      }
      return await items.doc().set({
        'rank': rank,
        'name': displayNames['en'],
        'displayName': displayNames,
        'imageUrl': url,
        'category': categories,
        'quality': varieties,
        'searchArray': searchArray,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> updateCategory(
      {Map category, File fileImage, int priority}) async {
    QuerySnapshot ds =
        await categories.where('name', isEqualTo: category['en']).get();

    if (ds.docs.length == 0) {
      List<String> searchArray = [];
      for (String name in category.values) {
        for (var i = 0; i < name.length; i++) {
          searchArray.add(name.substring(0, i + 1));
        }
      }
      try {
        StorageUploadTask task = storage
            .ref()
            .child("category_images")
            .child("${DateTime.now().millisecondsSinceEpoch.toString()}.jpg")
            .putFile(fileImage);
        StorageTaskSnapshot snapshot = await task.onComplete;
        String url = await snapshot.ref.getDownloadURL();
        await categories.doc().set({
          'displayNames': category,
          'name': category['en'],
          'imageUrl': url,
          'searchArray': searchArray,
          'priority': priority
        });
      } catch (e) {
        print(e.toString());
      }
      return true;
    } else {
      myToast('Category already exists');
      return false;
    }
  }
}
