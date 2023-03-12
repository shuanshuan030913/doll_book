import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doll_app/models/item.dart';
import 'package:doll_app/ui/screens/list/item_card.dart';
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

  Stream<List<Item>> _itemsStream = Stream.value([]);

  final User user = FirebaseAuth.instance.currentUser!;

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
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      List<Item> items = [];
      return items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Color.fromARGB(255, 234, 198, 181),
              ),
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
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: StreamBuilder<List<Item>>(
              stream: _itemsStream,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => EditPage(item: item),
                            //   ),
                            // );
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
    );
  }
}
