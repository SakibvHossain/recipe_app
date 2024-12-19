import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/utils/constants.dart';
import 'package:recipe_app/views/ViewAllItems.dart';
import 'package:recipe_app/widgets/banner.dart';
import 'package:recipe_app/widgets/food_item_display.dart';
import 'package:recipe_app/widgets/my_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = "All";

  //For category
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection("App-Category");

  //For all item display
  Query get filteredRecipes => FirebaseFirestore.instance
      .collection('Complete-Flutter-App')
      .where('category', isEqualTo: category);

  Query get allRecipes =>
      FirebaseFirestore.instance.collection('Complete-Flutter-App');

  Query get selectedRecipes => category == "All" ? allRecipes : filteredRecipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerParts(),
                    mySearchBar(),
                    BannerPart(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //todo: Category
                    selectedCategory(),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quick & Easy',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ViewAllItems()));
                          },
                          child: Text(
                            'View all',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: selectedRecipes.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    final List<DocumentSnapshot> recipes =
                        streamSnapshot.data?.docs ?? [];
                    return Padding(
                      //Todo: Recent work
                      padding: EdgeInsets.only(top: 5, left: 15, bottom: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: recipes
                              .map((e) => FoodItemDisplay(documentSnapshot: e))
                              .toList(),
                        ),
                      ),
                    );
                  }
                  // Means that if snapshot has date then show the date otherwise show indicator
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerParts() {
    return Row(
      children: [
        Text(
          'What are you\ncooking today?',
          style:
              TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1),
        ),
        Spacer(),
        MyIconButton(icon: Iconsax.notification, pressed: () {})
      ],
    );
  }

  Widget mySearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Iconsax.search_normal),
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: "Search any recipes",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none)),
      ),
    );
  }

  //todo: https://www.youtube.com/watch?v=JdVu04EC7kE (time: 1:01:14)

  Widget selectedCategory() {
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          category == streamSnapshot.data!.docs[index]["name"]
                              ? kPrimaryColor
                              : Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            category == streamSnapshot.data!.docs[index]["name"]
                                ? Colors.white
                                : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        // Means that if snapshot has date then show the date otherwise show indicator
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget loadImage(){
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                    (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                      category == streamSnapshot.data!.docs[index]["name"]
                          ? kPrimaryColor
                          : Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                        category == streamSnapshot.data!.docs[index]["name"]
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        // Means that if snapshot has date then show the date otherwise show indicator
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
