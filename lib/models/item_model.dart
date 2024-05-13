import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String vendorUsername;
  final String vendorProfilePicUrl;
  final String description;
  final String vendorUid;
  final String itemId;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished; // the actual date published
  final String draftDate; // date entered by user
  final String pushedDate;
  final String agent;
  final String agentPhoneNumber;
  final String weaverPhoneNumber;
  final String weaver;
  final String weaverProductName;
  final String draftProductName;
  final String pushedProductName;
  final String pushedDescription;
  final List<String> draftImageLinks;
  final List<String> pushedImageLinks;
  final String draftRate;
  final String pushedRate;
  final bool isPushedToSale;

  const ItemModel({
    required this.isPushedToSale,
    required this.pushedDescription,
    required this.vendorUsername,
    required this.vendorProfilePicUrl,
    required this.description,
    required this.vendorUid,
    required this.itemId,
    required this.datePublished,
    required this.draftImageLinks,
    required this.pushedImageLinks,
    required this.agent,
    required this.pushedRate,
    required this.draftDate,
    required this.agentPhoneNumber,
    required this.draftProductName,
    required this.draftRate,
    required this.pushedDate,
    required this.pushedProductName,
    required this.weaver,
    required this.weaverPhoneNumber,
    required this.weaverProductName,
  });

  Map<String, dynamic> toJson() => {
        "vendorUsername": vendorUsername,
        "vendorProfilePicUrl": vendorProfilePicUrl,
        "description": description,
        "vendorUid": vendorUid,
        "itemId": itemId,
        "datePublished": datePublished,
        "draftDate": draftDate,
        "pushedDate": pushedDate,
        "agent": agent,
        "agentPhoneNumber": agentPhoneNumber,
        "weaverPhoneNumber": weaverPhoneNumber,
        "weaver": weaver,
        "weaverProductName": weaverProductName,
        "draftProductName": draftProductName,
        "pushedProductName": pushedProductName,
        "draftImageLinks": draftImageLinks,
        "pushedImageLinks": pushedImageLinks,
        "draftRate": draftRate,
        "pushedRate": pushedRate,
        "pushedDescription": pushedDescription,
        "isPushedToSale": isPushedToSale
      };

  static ItemModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ItemModel(
      isPushedToSale: snapshot['isPushedToSale'],
      pushedDescription: snapshot['pushedDescription'],
      vendorProfilePicUrl: snapshot['vendorProfilePicUrl'],
      vendorUsername: snapshot['vendorUsername'],
      vendorUid: snapshot['vendorUid'],
      description: snapshot['description'],
      itemId: snapshot['itemId'],
      datePublished: snapshot['datePublished'],
      draftImageLinks: List<String>.from(snapshot['draftImageLinks']),
      pushedImageLinks: List<String>.from(snapshot['pushedImageLinks']),
      draftRate: snapshot['draftRate'],
      pushedRate: snapshot['pushedRate'],
      agent: snapshot['agent'],
      agentPhoneNumber: snapshot['agentPhoneNumber'],
      draftDate: snapshot['draftDate'],
      draftProductName: snapshot['draftProductName'],
      pushedDate: snapshot['pushedDate'],
      pushedProductName: snapshot['pushedProductName'],
      weaver: snapshot['weaver'],
      weaverPhoneNumber: snapshot['weaverPhoneNumber'],
      weaverProductName: snapshot['weaverProductName'],
    );
  }
}
