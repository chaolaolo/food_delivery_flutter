import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/constants.dart';
import 'package:food_delivery/widget/food_item_display.dart';
import 'package:food_delivery/widget/my_icon_button.dart';
import 'package:iconsax/iconsax.dart';

class ViewAllItemsScreen extends StatefulWidget {
  const ViewAllItemsScreen({super.key});

  @override
  State<ViewAllItemsScreen> createState() => _ViewAllItemsScreenState();
}

class _ViewAllItemsScreenState extends State<ViewAllItemsScreen> {
  final CollectionReference products = FirebaseFirestore.instance.collection("Product");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false, //remove app bar back button
        elevation: 0,
        actions: [
          SizedBox(
            width: 15,
          ),
          MyIconButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          Text(
            "Quick & Easy",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          MyIconButton(
            icon: Iconsax.notification,
            onPressed: () {},
          ),
          SizedBox(width: 15)
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 5),
        child: Column(
          children: [
            const SizedBox(height: 10),
            StreamBuilder(
              stream: products.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                      return Column(
                        children: [
                          FoodItemDisplay(documentSnapshot: documentSnapshot),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Iconsax.star1,
                                color: Colors.amberAccent,
                              ),
                              Text("${documentSnapshot["rating"]}/5",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text("${documentSnapshot["reviews"]} reviews",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}
