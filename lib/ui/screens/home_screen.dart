import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:doll_app/ui/components/item_page.dart';
import 'package:doll_app/ui/components/add_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _trackingScrollController,
        slivers: <Widget>[
          const SliverAppBar(
            title: Text('Home Screen'),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: const Text(
                        "List of Items",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      shrinkWrap: true,
                      children: List.generate(7, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemPage(index: index),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                'Item $index',
                              )
                            )
                          )
                        );
                      })
                    ),
                ]
              )
            )
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
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

