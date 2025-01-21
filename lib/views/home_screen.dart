import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/constants.dart';
import 'package:food_delivery/views/all_items_screen.dart';
import 'package:food_delivery/widget/banner.dart';
import 'package:food_delivery/widget/food_item_display.dart';
import 'package:food_delivery/widget/my_icon_button.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = "All";

  // for category
  final CollectionReference categoriesItems = FirebaseFirestore.instance.collection("Category");

  // for all items display
  Query get filteredRecipes => FirebaseFirestore.instance.collection("Product").where("category", isEqualTo: category);

  Query get allRecipes => FirebaseFirestore.instance.collection("Product");

  Query get selectedRecipes => category == "All" ? allRecipes : filteredRecipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerParts(),
                  searchBar(),
                  const BannerToExpore(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // load category
                  selectedCategory(),
                  const SizedBox(
                    height: 6,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quick & Easy",
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ViewAllItemsScreen(),
                              ));
                        },
                        child: Text(
                          "View all",
                          style: TextStyle(
                            color: kBannerColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            StreamBuilder(
              stream: selectedRecipes.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> recipes = snapshot.data?.docs ?? [];
                  return Padding(
                    padding: EdgeInsets.only(top: 5, left: 15),
                    // child: SizedBox(
                    //   // height: 200,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: recipes.length,
                    //     itemBuilder: (context, index) {
                    //       return Container(
                    //         margin: EdgeInsets.only(right: 10),
                    //         width: 150,
                    //         child: FoodItemDisplay(documentSnapshot: recipes[index]),
                    //       );
                    //     },
                    //   ),
                    // ),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: recipes
                                .map((e) =>
                                    // Container(
                                    // width: double.infinity,
                                    // margin: EdgeInsets.only(right: 10),
                                    // width: 150,
                                    // child:
                                    FoodItemDisplay(documentSnapshot: e))
                                // )
                                .toList())),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        )),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
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
                      // if the data is already exists then it work when you choose the category
                      category = streamSnapshot.data!.docs[index]["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: category == streamSnapshot.data!.docs[index]["name"] ? kPrimaryColor : Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    margin: EdgeInsets.only(right: 16),
                    child: Text(
                      streamSnapshot.data!.docs[index]["name"],
                      style: TextStyle(
                        color: category == streamSnapshot.data!.docs[index]["name"] ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Row headerParts() {
    return Row(
      children: [
        const Text(
          "What are you\ncooking today?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const Spacer(),
        MyIconButton(icon: Iconsax.notification, onPressed: () {})
      ],
    );
  }

  Padding searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(
            Iconsax.search_normal,
          ),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: "Search any recipes",
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
