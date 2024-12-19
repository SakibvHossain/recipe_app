import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];

  List<String> get favorites => _favoriteIds;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FavoriteProvider() {
    laodFavorites();
  }

  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(productId);
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(productId);
    }
    notifyListeners();
  }

  bool isExist(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  //Add to favorite product
  Future<void> _addFavorite(String productId) async {
    try {
      await _firestore
          .collection("userFavorite")
          .doc(productId)
          .set({'isFavorite': true});
    } catch (e) {
      print(e.toString());
    }
  }

  //Remove from favorite product
  Future<void> _removeFavorite(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //Load favorites recipes from fire store
  Future<void> laodFavorites() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection("userFavorite").get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}
