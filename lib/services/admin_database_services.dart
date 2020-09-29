import 'package:cloud_firestore/cloud_firestore.dart';

class AdminServices {
  final admin = FirebaseFirestore.instance.collection("adminDetials");
  final location = FirebaseFirestore.instance.collection("locations");
  String adminName;
  String nextDeliveryTime;
  int fastDeliveryAmount;
  int freeFastDeliveryAmount;
  List<Map> locations;
  List<String> areaNames;

  Future<bool> updateAdminDetails(
      {String adminName,
      String nextDeliveryTime,
      int fastDeliveryAmount,
      int freeFastDeliveryAmount,
      List<dynamic> locations,
      List<String> areaNames,
      String uid}) async {
    try {
      await admin.doc('yN7N5geufqe2XmoKnyYyHPrajaR2').set({
        'adminName': adminName,
        'nextDeliveryTime': nextDeliveryTime,
        'fastDeliveryAmount': fastDeliveryAmount,
        'freeFastDeliveryAmount': freeFastDeliveryAmount,
        'areaNames': areaNames,
      });
      for (var loc in locations) {
        if (loc['documentId'] == null || loc['documentId'] == '') {
          var refDoc = location.doc();
          loc['documentId'] = refDoc.id;
          refDoc.set(loc);
        } else {
          await location.doc(loc['documentId']).set(loc);
        }
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<DocumentSnapshot> getAdminDetails() async {
    return await admin.doc('yN7N5geufqe2XmoKnyYyHPrajaR2').get();
  }

  Future getLocations() async {
    var result = await location.orderBy('area').get();
    return result;
  }
}
