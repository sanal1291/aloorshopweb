import 'package:firebase/firebase.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freshgrownweb/models/indipendentItem.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

class AddPackageService {
  final package = FirebaseFirestore.instance.collection("packages");
  final storage = FirebaseStorage.instance;

  Future addPackage(
      {String name,
      List<IndiItem> items,
      String uid,
      MediaInfo fileInfo,
      int price,
      int total,
      String imageUrl}) async {
    List tempItems = [];
    for (IndiItem i in items) {
      tempItems.add({'item': i.uid, 'quantity': i.quantity});
    }
    String url = imageUrl;
    try {
      if (fileInfo != null) {
        String mimeType = mime(basename(fileInfo.fileName));
        var metaData = fb.UploadMetadata(contentType: mimeType);
        fb.StorageReference _storage =
            fb.storage().ref('packages/${fileInfo.fileName}$name} ');
        fb.UploadTaskSnapshot uploadTaskSnapshot =
            await _storage.put(fileInfo.data, metaData).future;
        var imageUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        url = imageUrl.toString();
      }
      package.doc(uid ?? null).set({
        'name': name,
        'items': tempItems,
        'image': url,
        'price': price,
        'total': total,
      });
      return true;
    } catch (e) {
      return false;
    }
    // print(fileInfo);
  }
}
