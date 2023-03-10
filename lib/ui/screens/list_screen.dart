import 'package:doll_app/ui/screens/home/detail_page.dart';
import 'package:doll_app/ui/screens/list/list_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doll_app/ui/screens/home/add_page.dart';
import 'package:doll_app/models/item.dart';
import 'package:doll_app/ui/screens/list/item_card.dart';
import 'package:doll_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // the initial selected status
  String _filterStatus = '不限';
  bool _isSwitched = false;

  Stream<List<Item>> _itemsStream = Stream.value([]);

  final User user = FirebaseAuth.instance.currentUser!;

// Initialize a Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List _items = [];

  @override
  void initState() {
    super.initState();
    _itemsStream = getDataFromFirestore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _itemsStream = getDataFromFirestore();
  }

  Stream<List<Item>> getDataFromFirestore() {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('data');
    return collectionReference
        .doc(user.uid)
        .collection('items')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<Item> items = [];
      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        Item item = Item.fromMap(doc.data()!, doc.id);
        items.add(item);
      });
      return items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 50,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 55.0,
                    title: Text('我的娃'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Handle edit button press
                          print('edit');
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: DropdownButton(
                        value: _filterStatus,
                        isExpanded: true,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              _filterStatus = newValue;
                            });
                          }
                        },
                        items: filterOptions.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16.0),
                    sliver: StreamBuilder<List<Item>>(
                      stream: _itemsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Item>> snapshot) {
                        if (snapshot.hasError) {
                          return SliverToBoxAdapter(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final List<Item> data = snapshot.data!;

                        List<Item> filteredItems = _filterStatus == '不限'
                            ? data
                            : data
                                .where((item) => item.status == _filterStatus)
                                .toList();

                        if (filteredItems.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Text('找不到娃(◞‸◟ ) 💔'),
                            ),
                          );
                        }

                        return SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final Item item = filteredItems[index];
                              return GestureDetector(
                                  onTap: () {
                                    print('${user.uid}');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          collectionReference:
                                              firestore.collection('items'),
                                          data: item,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ItemCard(item: item));
                            },
                            childCount: filteredItems.length,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 62.0,
              right: 16.0,
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: Opacity(
                  opacity: 0.8,
                  child: FloatingActionButton(
                    foregroundColor: Colors.white,
                    elevation: 0.0, // Remove the shadow
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddItemPage(
                              collectionReference:
                                  firestore.collection('items')),
                        ),
                      ).then((newItem) {
                        // print(newItem);
                        if (newItem != null) {
                          setState(() {
                            _items.add(newItem);
                          });
                        }
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        left: 0,
        bottom: 0,
        right: 0,
        child: Container(
          height: 50, // The height of your bottom bar
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Your bottom bar buttons here
              ListSwitch(
                value: _isSwitched,
                onToggle: (val) {
                  setState(() {
                    _isSwitched = val;
                  });
                },
                activeText: '顯示娃娃',
                inactiveText: '隱藏娃娃',
              ),
              ListSwitch(
                value: _isSwitched,
                onToggle: (val) {
                  setState(() {
                    _isSwitched = val;
                  });
                },
                activeText: '顯示娃衣',
                inactiveText: '隱藏娃衣',
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
