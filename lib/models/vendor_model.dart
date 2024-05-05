import 'package:cloud_firestore/cloud_firestore.dart';

class VendorModel {
  String username;
  String profilePic; // will be set later from the DB
  String email;
  String uid;
  String gstin;
  String ownerName; // if the vendor decides to keep seperate than the user name
  String officeAddress;
  String storeName;
  String phoneNumber;
  bool isSubscribed; // if the vendor has subscribed for a seperate customer app
  String vendorsAppBundleId;

  VendorModel({
    required this.username,
    required this.email,
    required this.profilePic,
    required this.uid,
    required this.ownerName,
    required this.phoneNumber,
    required this.isSubscribed,
    required this.officeAddress,
    required this.gstin,
    required this.storeName,
    required this.vendorsAppBundleId,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "profilePic": profilePic,
      "email": email,
      "uid": uid,
      "phoneNumber": phoneNumber,
      "officeAddress": officeAddress,
      "gstin": gstin,
      "isSubscribed": isSubscribed,
      "ownerName": ownerName,
      "vendorAppBundleId": vendorsAppBundleId,
      "storeName": storeName,
    };
  }

  static VendorModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return VendorModel(
        storeName: snapshot['storeName'],
        vendorsAppBundleId: snapshot['vendorsAppBundleId'],
        ownerName: snapshot['ownerName'],
        username: snapshot['username'],
        email: snapshot['email'],
        profilePic: snapshot['profilePic'],
        uid: snapshot['uid'],
        phoneNumber: snapshot['phoneNumber'],
        isSubscribed: snapshot['isSubscribed'],
        officeAddress: snapshot['officeAddress'],
        gstin: snapshot['gstin']);
  }
}
