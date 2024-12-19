import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/provider/favorite_button_provider.dart';
import 'package:recipe_app/provider/quantity.dart';
import 'package:recipe_app/utils/constants.dart';
import 'package:recipe_app/widgets/my_icon_button.dart';
import 'package:recipe_app/widgets/quantity_inc_dec.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;

  const RecipeDetailScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {

  @override
  void initState() {
    // Initialize base ingredient amounts in the provider
    List<double> baseAmounts = widget.documentSnapshot['ingredientsAmount']
    .map<double>((amount) => double.parse(amount.toString())).toList();

    Provider.of<QuantityProvider>(context, listen: false).setBaseIngredientAmounts(baseAmounts);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startCookingAndFavButton(provider),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                //For image
                Hero(
                  tag: widget.documentSnapshot['image'],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              widget.documentSnapshot['image'],
                            ))),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      MyIconButton(
                        icon: Icons.arrow_back_ios_new,
                        pressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      MyIconButton(
                        icon: Iconsax.notification,
                        pressed: () {},
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            //Drag handle
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot["name"],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.flash_1,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "${widget.documentSnapshot['cal']} Cal",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "${widget.documentSnapshot['time']} Min",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //For rating
                  Row(
                    children: [
                      Icon(
                        Iconsax.star1,
                        color: Colors.amberAccent,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.documentSnapshot['rating'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('/5'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${widget.documentSnapshot['reviews'.toString()]} Reviews",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredients',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'How many serving?',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      QuantityIncDec(
                          currentNumber: quantityProvider.currentNumber,
                          onAdd: () => quantityProvider.increaseQuantity(),
                          onRemove: () => quantityProvider.decreaseQuantity())
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Column(
                    children: [
                      Row(
                        children: [
                          //Ingredient image
                          Column(
                            children: widget
                                .documentSnapshot['ingredientsImage']
                                .map<Widget>(
                              (imageUrl) => Container(
                                height: 60,
                                width: 60,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      imageUrl
                                    ),
                                  ),
                                ),
                              ),
                            ).toList(),
                          ),
                          SizedBox(width: 20,),
                          //Ingredient name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget
                                .documentSnapshot['ingredientsName']
                                .map<Widget>(
                                  (ingredientNames) => SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        ingredientNames,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade400
                                        ),
                                      ),
                                    ),
                                  ),
                            ).toList(),
                          ),
                          //Ingredient amount
                          Spacer(),
                          Column(
                            children: quantityProvider.updateIngredientAmounts
                                .map<Widget>(
                                  (amounts) => SizedBox(
                                height: 60,
                                child: Center(
                                  child: Text(
                                    "${amounts}gm",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade400
                                    ),
                                  ),
                                ),
                              ),
                            ).toList(),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }

  FloatingActionButton startCookingAndFavButton(FavoriteProvider provider) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 8),
                  foregroundColor: Colors.white),
              onPressed: () {},
              child: Text(
                "Start Cooking",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              style: IconButton.styleFrom(
                  side: BorderSide(
                color: Colors.grey.shade300,
                width: 2,
              )),
              onPressed: () {
                provider.toggleFavorite(widget.documentSnapshot);
              },
              icon: Icon(
                provider.isExist(widget.documentSnapshot)
                    ? Iconsax.heart5
                    : Iconsax.heart,
                color: provider.isExist(widget.documentSnapshot)
                    ? Colors.red
                    : Colors.black,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
