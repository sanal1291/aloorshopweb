import 'package:firebase/firebase.dart' as fb;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshgrownweb/models/item.dart';
import 'package:freshgrownweb/shared/constants.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

class EditProductService {
  final items = FirebaseFirestore.instance.collection("items");

  Future editProductData({
    Item item,
    MediaInfo fileImage,
  }) async {
    if (fileImage != null) {
      fb.StorageReference _storage = fb.storage().refFromURL(item.imageUrl);
      await _storage.delete();
      String mimeType = mime(basename(fileImage.fileName));
      var metaData = fb.UploadMetadata(contentType: mimeType);
      fb.StorageReference _newstorage =
          fb.storage().ref('product_images/${fileImage.fileName}');
      fb.UploadTaskSnapshot uploadTaskSnapshot =
          await _newstorage.put(fileImage.data, metaData).future;
      var imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      String url = imageUri.toString();
      item.imageUrl = url;
      try {
        DocumentReference docRef = items.doc(item.uid);
        docRef.update({
          'rank': item.rank,
          'name': item.displayNames['en'],
          'displayName': item.displayNames,
          'imageUrl': item.imageUrl,
          'varieties': item.varieties,
          'inStock': item.inStock,
        });
      } catch (e) {
        print(e.toString());
        myToast("something went wrong");
      }
    }
  }
}
