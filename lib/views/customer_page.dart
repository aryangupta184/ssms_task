

import 'package:flutter/material.dart';

import 'package:ssms_revamp/router/route_utils.dart';
import 'package:ssms_revamp/views/signin_page.dart';
import 'package:go_router/go_router.dart';
import 'package:ssms_revamp/views/login_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class CustomerPage extends StatefulWidget {
  CustomerPage({Key? key}) : super(key: key);

  @override
  _CustomerPage createState() => _CustomerPage();
}

class _CustomerPage extends State<CustomerPage> {

  double price = 0;

  double height = 200;

  String? username = SignInPage.sendusername.toString();

  static const snackBar = SnackBar(
    content: Text('User Signed Out Successfully'),
  );


  final CollectionReference _items =
  FirebaseFirestore.instance.collection('items');





  final TextEditingController _cartController = TextEditingController();

  Future<void> _updatecart(DocumentSnapshot? documentSnapshot) async {
    if (documentSnapshot != null) {
      _cartController.text = documentSnapshot['cart'].toString();

    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Add this item to cart",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _cartController,
                  decoration: const InputDecoration(
                      labelText: 'Cart', hintText: 'eg.0'),
                ),

                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {

                      int? cart= int.tryParse(_cartController.text);

                        await _items
                            .doc(documentSnapshot!.id)
                            .update({"cart":cart});
                        // await _items
                        //     .doc(documentSnapshot!.id)
                        //     .update({"price":tempprice.toString()});

                        price+=cart!*documentSnapshot['sn'];
                        print(price);
                        setState(() {

                        });







                    },
                    child: const Text("Add to Cart"))
              ],
            ),
          );
        });
  }








  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 6.0,
        shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            )),
        backgroundColor: Colors.black,


        leading: Icon(
          Icons.account_circle_rounded,
          color: Colors.white,
        ),
        title: Text(
          "Hi, " + username!,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
              width: 100,
              child: TextButton(
                onPressed: () {
                  SignInPage.sendusername = 'User';
                  FirebaseServices().signOut();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  GoRouter.of(context).push(APP_PAGE.home.toPath);
                },
                child: Text(
                  "Log out",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )),
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
        },
        backgroundColor: Colors.black,
        label: Text("Cart Value: " + price.toString()),

      ),




      // FloatingActionButton(
      //   onPressed: () => _create(),
      //   backgroundColor: const Color.fromARGB(255, 88, 136, 190),
      //   child: const Icon(Icons.add),
      // ),
      body: StreamBuilder(
        stream: _items.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {

            final List<DocumentSnapshot> items =
            streamSnapshot.data!.docs.toList();
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = items[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          "Rs. " + documentSnapshot['sn'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                      title: Text(
                        documentSnapshot['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),

                      subtitle: Text("In Cart: " +documentSnapshot['cart'].toString(),
                      style: const TextStyle(
                          color: Colors.blueAccent
                      ),),
                      trailing: SizedBox(
                        width: 50,
                        child: Row(
                          children: [
                            IconButton(
                                color: Colors.black,
                                onPressed: () async {
                                    await _updatecart(documentSnapshot);
                                    setState(() {
                                    });

                                },
                                icon: const Icon(Icons.add_circle)),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

