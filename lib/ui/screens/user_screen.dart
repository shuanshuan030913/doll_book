import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _trackingScrollController,
      slivers: [
        SliverAppBar(
          title: Text('User Screen'),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Placeholder(
                fallbackHeight: 50,
                fallbackWidth: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('user: Hello'),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
