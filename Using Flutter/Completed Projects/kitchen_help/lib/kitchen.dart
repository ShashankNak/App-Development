import 'package:flutter/material.dart';
import 'package:kitchen_help/tabs/beverages.dart';
import 'package:kitchen_help/tabs/pantry.dart';
import 'package:kitchen_help/tabs/vegeies.dart';

class Kitchen extends StatefulWidget {
  const Kitchen({super.key});

  @override
  State<Kitchen> createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 166, 150),
        title: const Text("Kitchen"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
        bottom: TabBar(
          splashBorderRadius: BorderRadius.circular(40),
          indicatorPadding: const EdgeInsets.only(bottom: 4),
          physics: const BouncingScrollPhysics(),
          labelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(
              text: "Vegies",
            ),
            Tab(
              text: "Pantry",
            ),
            Tab(
              text: "Beverages",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.normal,
        ),
        children: const [
          Vegies(),
          Pantry(),
          Beverages(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
        onPressed: () {},
      ),
    );
  }
}
