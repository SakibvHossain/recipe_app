import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/provider/favorite_button_provider.dart';
import 'package:recipe_app/utils/constants.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteItem = provider.favorites;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        centerTitle: true,
        title: Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: favoriteItem.isEmpty
          ? Center(
              child: Text(
                "No Favorite Item found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: favoriteItem.length,
              itemBuilder: (context, index) {
                String favorite = favoriteItem[index];
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("Complete-Flutter-App")
                        .doc(favorite)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                          child: Text('Error loading favorites'),
                        );
                      }
                      var favoriteItems = snapshot.data!;

                      return Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                          image: NetworkImage(
                                            favoriteItems['image']
                                          ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        favoriteItems['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.flash_1,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "${favoriteItems['cal']} Cal",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            ".",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900, color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Iconsax.clock,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "${favoriteItems['time']} Min",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Delete button
                          Positioned(
                            top: 50,
                            right: 35,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  provider.toggleFavorite(favoriteItems);
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
            ),
    );
  }
}
