import 'package:flutter/material.dart';
import 'package:kitchen_help/model/meal.dart';
import 'package:kitchen_help/widget/dummy_data.dart';
import 'package:kitchen_help/widget/meal_item.dart';

class CategoryMealScreen extends StatefulWidget {
  final String availableMealId;
  final String title;

  const CategoryMealScreen(this.availableMealId, this.title, {super.key});

  @override
  State<CategoryMealScreen> createState() => _CategoryMealScreenState();
}

class _CategoryMealScreenState extends State<CategoryMealScreen> {
  late String categoryTitle;
  late List<Meal> displayedMeals;
  var _loadedInitData = false;

  @override
  void initState() {
    super.initState();
    if (!_loadedInitData) {
      categoryTitle = widget.title;
      displayedMeals = dummyMeals
          .where(
              (element) => element.categories.contains(widget.availableMealId))
          .toList();
      _loadedInitData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 166, 150),
        title: Text(categoryTitle),
      ),
      body: displayedMeals.isEmpty
          ? const Center(
              child: Text("You don't have any recipe yet!.."),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return MealItem(
                  id: displayedMeals[index].id,
                  title: displayedMeals[index].title,
                  image: displayedMeals[index].image,
                  duration: displayedMeals[index].duration,
                  complexity: displayedMeals[index].complexity,
                  affordability: displayedMeals[index].affordability,
                );
              },
              itemCount: displayedMeals.length,
            ),
    );
  }
}
