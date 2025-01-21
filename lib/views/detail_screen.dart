import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/provider/favourite_provider.dart';
import 'package:food_delivery/provider/quantity.dart';
import 'package:food_delivery/utils/constants.dart';
import 'package:food_delivery/widget/my_icon_button.dart';
import 'package:food_delivery/widget/quantity_increment_decrement.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;

  const DetailScreen({super.key, required this.documentSnapshot});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    //init base ingredient amounts in the provider
    List<double> baseAmounts = widget.documentSnapshot["ingredientsAmount"]
        .map<double>((amount) => double.parse(
              amount.toString(),
            ))
        .toList();
    Provider.of<QuantityProvider>(context, listen: false).setBaseIngredientAmounts(baseAmounts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavouriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startCookingAndFavouriteButton(provider),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.documentSnapshot["image"],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.documentSnapshot["image"],
                        ),
                      ),
                    ),
                  ),
                ),
                //for back button
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      MyIconButton(
                          icon: Icons.arrow_back_ios_new,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Spacer(),
                      MyIconButton(
                        icon: Iconsax.notification,
                        onPressed: () {},
                      ),
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
                    )),
              ],
            ),
            // for drag handle
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
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot["name"],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Iconsax.flash_1,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "${widget.documentSnapshot["cal"]} Cal",
                        style: TextStyle(
                          fontSize: 14,
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
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${widget.documentSnapshot["time"]} Min",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // for rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Iconsax.star1,
                        color: Colors.amberAccent,
                      ),
                      Text("${widget.documentSnapshot["rating"]}/5",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text("${widget.documentSnapshot["reviews"]} reviews",
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Infredients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "How many servings?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      QuantityIncrementDecrement(
                        currentNumber: quantityProvider.currentNumber,
                        onAdd: () => quantityProvider.incrementQuantity(),
                        onRemove: () => quantityProvider.decrementQuantity(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  //list of ingredients
                  Column(
                    children: [
                      Row(
                        children: [
                          //ingredient image
                          Column(
                            children: widget.documentSnapshot["ingredientsImage"]
                                .map<Widget>(
                                  (imageUrl) => Container(
                                    height: 60,
                                    width: 60,
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(imageUrl),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(width: 20),
                          //ingredient name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.documentSnapshot["ingredientsName"]
                                .map<Widget>((ingredient) => SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          ingredient,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          //ingredient amount
                          Spacer(),
                          Column(
                            children: quantityProvider.updateIngredientAmounts
                                .map<Widget>((amount) => SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          "${amount}gm",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 40)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton startCookingAndFavouriteButton(FavouriteProvider provider) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 12,
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: Text(
                "Start cooking",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              style: IconButton.styleFrom(
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
              ),
              onPressed: () {
                provider.toggleFavourite(widget.documentSnapshot);
              },
              icon: Icon(
                provider.isExist(widget.documentSnapshot) ? Iconsax.heart5 : Iconsax.heart,
                color: provider.isExist(widget.documentSnapshot) ? Colors.red : Colors.black,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
