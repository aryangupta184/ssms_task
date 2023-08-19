import 'package:flutter/material.dart';

import 'package:ssms_revamp/router/route_utils.dart';
import 'package:ssms_revamp/views/signin_page.dart';
import 'package:go_router/go_router.dart';
import 'package:ssms_revamp/views/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  double height = 200;

  String? username = SignInPage.sendusername.toString();

  static const snackBar = SnackBar(
    content: Text('User Signed Out Successfully'),
  );
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _snController = TextEditingController();

  final CollectionReference _items =
      FirebaseFirestore.instance.collection('items');

  String searchText = '';
  // for create operation
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
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
                    "Create your item",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name', hintText: 'eg.Elon'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _snController,
                  decoration: const InputDecoration(
                      labelText: 'Price', hintText: 'eg.1'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                  decoration: const InputDecoration(
                      labelText: 'Stock', hintText: 'eg.10'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      final int? sn = int.tryParse(_snController.text);
                      final int? number = int.tryParse(_numberController.text);
                      if (number != null) {
                        await _items.add({
                          "name": name,
                          "number": number,
                          "sn": sn,
                          "cart": 0
                        });
                        _nameController.text = '';
                        _snController.text = '';
                        _numberController.text = '';

                        GoRouter.of(context).push(APP_PAGE.login.toPath);
                      }
                    },
                    child: const Text("Create"))
              ],
            ),
          );
        });
  }

  // for Update operation
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _snController.text = documentSnapshot['sn'].toString();
      _numberController.text = documentSnapshot['number'].toString();
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
                    "Update your item",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name', hintText: 'eg.Elon'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _snController,
                  decoration: const InputDecoration(
                      labelText: 'Cost', hintText: 'eg.1'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                  decoration: const InputDecoration(
                      labelText: 'Stock', hintText: 'eg.10'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      final int? sn = int.tryParse(_snController.text);
                      final int? number = int.tryParse(_numberController.text);
                      if (number != null) {
                        await _items
                            .doc(documentSnapshot!.id)
                            .update({"name": name, "number": number, "sn": sn});
                        _nameController.text = '';
                        _snController.text = '';
                        _numberController.text = '';

                        GoRouter.of(context).push(APP_PAGE.login.toPath);
                      }
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        });
  }

  // for delete operation
  Future<void> _delete(String productID) async {
    await _items.doc(productID).delete();

    // for snackBar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have successfully deleted a item")));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
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
                    color: Colors.blueGrey,
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
                              color: Colors.greenAccent),
                        ),
                      ),
                      // leading: CircleAvatar(
                      //   radius: 60,
                      //   backgroundColor: Colors.black,
                      //   child: Text("Rs. " +
                      //     documentSnapshot['sn'].toString(),
                      //     style: const TextStyle(
                      //         fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      //   ),
                      // ),
                      title: Text(
                        documentSnapshot['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                          "Stock: " + documentSnapshot['number'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                color: Colors.white,
                                onPressed: () => _update(documentSnapshot),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                color: Colors.white,
                                onPressed: () => _delete(documentSnapshot.id),
                                icon: const Icon(Icons.delete)),
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
