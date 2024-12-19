import 'package:flutter/material.dart';
import 'package:recipe_app/utils/constants.dart';

class BannerPart extends StatelessWidget {
  const BannerPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: kBannerColor),
      child: Stack(
        children: [
          Positioned(
            top: 32,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cook the best\nrecipes at home",
                  style: TextStyle(
                      height: 1.1,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 33),
                      backgroundColor: Colors.white,
                      elevation: 0),
                  onPressed: () {},
                  child: Text(
                    "Explore",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://raw.githubusercontent.com/SakibvHossain/Image_Storage/main/chef_female.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
