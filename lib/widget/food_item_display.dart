import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/provider/favourite_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class FoodItemDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;

  const FoodItemDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavouriteProvider.of(context);
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                height: 150,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(documentSnapshot["image"]),
                    )),
              ),
              SizedBox(height: 10),
              Text(
                documentSnapshot["name"],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Iconsax.flash_1,
                    size: 16,
                    color: Colors.grey,
                  ),
                  Text(
                    "${documentSnapshot["cal"]} Cal",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " . ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Icon(
                    Iconsax.clock,
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${documentSnapshot["time"]} Min",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          //favourite button
          //now let's who on favourite button using provider
          Positioned(
              top: 5,
              right: 15,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                    provider.toggleFavourite(documentSnapshot);
                  },
                  child: Icon(
                    provider.isExist(documentSnapshot) ? Iconsax.heart5 : Iconsax.heart,
                    color: provider.isExist(documentSnapshot)?Colors.red:Colors.black,
                    size: 20,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
