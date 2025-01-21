import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteProvider extends ChangeNotifier {
  List<String> _favouriteIds = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> get favourites => _favouriteIds;

  FavouriteProvider() {
    loadFavourite();
  }

  void toggleFavourite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favouriteIds.contains(productId)) {
      _favouriteIds.remove(productId);
      await _removeFavourite(productId); //remove from favourite
    } else {
      _favouriteIds.add(productId);
      await _addFavourite(productId); //add to favourite
    }
    notifyListeners();
  }

  //check  if a product is favourite
  bool isExist(DocumentSnapshot product) {
    return _favouriteIds.contains(product.id);
  }

  //add favourites to firestore
  Future<void> _addFavourite(String productId) async {
    try {
      await _firestore.collection("userFavourite").doc(productId).set({
        'isFavourite': true, //create the collection and add item as favourites inf firestore
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //remove favourites from firestore
  Future<void> _removeFavourite(String productId) async {
    try {
      await _firestore.collection("userFavourite").doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //load favourites from firestore (store favourite or not)
  Future<void> loadFavourite() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("userFavourite").get();
      _favouriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // static method to access th provider from any context
  static FavouriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavouriteProvider>(context, listen: listen);
  }
}
