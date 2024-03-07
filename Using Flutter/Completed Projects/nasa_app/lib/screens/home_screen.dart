import 'package:flutter/material.dart';
import 'package:nasa_app/screens/tabs/screen_1.dart';
import 'package:nasa_app/screens/tabs/screen_2.dart';
import 'package:nasa_app/screens/tabs/screen_3.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal,
          ),
          children: const [
            Screen1(),
            Screen2(),
            Screen3(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            bottom: size.height / 30,
            left: size.width / 20,
            right: size.width / 20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(size.width / 3)),
        padding: const EdgeInsets.all(10),
        width: size.width / 1.1,
        height: size.height / 18,
        child: TabBar(
          splashBorderRadius: BorderRadius.circular(40),
          dividerColor: Colors.white,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          automaticIndicatorColorAdjustment: true,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: Colors.white54,
          physics: const BouncingScrollPhysics(),
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.ac_unit_outlined),
            ),
            Tab(
              icon: Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
    );
  }
}
