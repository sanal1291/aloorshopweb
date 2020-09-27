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

  Future addProductData(
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
          'varieties': e['quality'],
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
        'varieties': varieties,
        'searchArray': searchArray,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> addCategory(
      {Map category, MediaInfo fileImage, int priority}) async {
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
        String mimeType = mime(basename(fileImage.fileName));
        var metaData = fb.UploadMetadata(contentType: mimeType);
        fb.StorageReference _storage =
            fb.storage().ref('category_images/${fileImage.fileName}');
        fb.UploadTaskSnapshot uploadTaskSnapshot =
            await _storage.put(fileImage.data, metaData).future;
        var imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        String url = imageUri.toString();
        await categories.doc().set({
          'displayNames': category,
          'name': category['en'],
          'imageUrl': url,
          'searchArray': searchArray,
          'priority': priority
        });
        myToast('Category successfully added');
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
