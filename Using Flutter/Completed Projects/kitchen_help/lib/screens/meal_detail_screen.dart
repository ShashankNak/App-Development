import 'package:flutter/material.dart';
import 'package:kitchen_help/model/meal.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key, required this.meal});
  final Meal meal;

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: 200,
        width: 300,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 166, 150),
        title: Text('Recipe: ${meal.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(height: 300, width: double.infinity, child: meal.image
              //  Image.network(
              //   meal.imageUrl,
              //   fit: BoxFit.cover,
              // ),

              ),
          buildSectionTitle(context, 'Ingredients'),
          buildContainer(
            ListView.builder(
              itemBuilder: (ctx, index) => Card(
                color: Colors.teal.shade300,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    meal.ingredients[index],
                  ),
                ),
              ),
              itemCount: meal.ingredients.length,
            ),
          ), //buildContainer
          buildSectionTitle(context, 'Steps'),
          buildContainer(ListView.builder(
            itemBuilder: (ctx, index) => Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade300,
                    child: Text('# ${index + 1}'),
                  ),
                  title: Text(meal.steps[index]),
                ),
                const Divider(),
              ],
            ),
            itemCount: meal.steps.length,
          )),
        ]),
      ),
    );
  }
}
