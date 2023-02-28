import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:doll_app/ui/screens/home/item_page.dart';
import 'package:doll_app/ui/screens/home/add_page.dart';
import 'package:doll_app/ui/components/item.dart';
import 'package:doll_app/ui/components/item_card.dart';
import 'package:doll_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // the initial selected status
  String _filterStatus = '不限';

  final User user = FirebaseAuth.instance.currentUser!;

  final List _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('娃口名簿'),
              centerTitle: true,
            ),
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
          // const SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.all(16.0),
          //     child: Text(
          //       '已登錄',
          //       style: TextStyle(
          //         fontSize: 18.0,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('data')
                  .doc(user.uid)
                  // .collection('items')
                  // .where('status',
                  //     isEqualTo: _filterStatus == '不限' ? null : _filterStatus)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
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

                final data = snapshot.data!['items'];
                print('data: ${snapshot.data!['items']}');

                if (data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('找不到娃(◞‸◟ ) 💔'),
                    ),
                  );
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final Item item = Item.fromMap(data[index]);
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemPage(item: item),
                              ),
                            );
                          },
                          child: ItemCard(item: item));
                    },
                    childCount: data.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemPage(),
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
    );
  }
}
