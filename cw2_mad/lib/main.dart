import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile APP CW 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  HomeScreen(title: 'HomeScreen'),
    );
  }
}

class RecipeDetails {
  final String title;
  final List<String> ingredients;
  final List<String> instructions;

  RecipeDetails(
      {required this.title, required this.ingredients, required this.instructions});
}

class HomeScreen extends StatelessWidget {
 HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  final Map<String, RecipeDetails> recipeDetails = {
    'Hungarian Goulash': RecipeDetails(
      title: 'Hungarian Goulash',
      ingredients: ['Onion', 'Oil', 'Beef','Tomato Products', 'garlic', 'soy sauce', 'Italian herb Seasoning', 'salt', 'bay leaves', 'Macaroni'],
      instructions: [
        'Step 1:Cook the onion in oil, then add the ground beef and cook until brown. Add garlic.',
        'Step 2: Stir in the water, tomatoes, and seasonings. Bring to a simmer.',
        'Step 3: Stir in uncooked noodles, cover, and simmer until pasta is tender.',
      ],
    ),
      'Shakshuka': RecipeDetails(
      title: 'Shakshuka',
      ingredients: ['Extra virgin olive oil', '1 large yellow onion chopped', '2 green peppers choped', '2 garlic cloves, chopped', '1 teaspoon of ground coriander', '1 tspn paprika', '1/2 tspn cumin','salt and pepper', '6 medium tomatoes chopped', '6 laege eggs', '1/4 cup chopped fresh paesley', '1/4 cup chopped fresh mint leaves' ],
      instructions: [
        'Step 1: Heat 3 tablespoon olive oil in a large cast iron skillet. Add the onions, green peppers, garlic, spices, pinch salt and pepper. Cook, stirring occasionally, until the vegetables have softened, about 5 minutes.',
        'Step 2: Add the tomatoes and tomato sauce. Cover and let simmer for about 15 minutes. Uncover and cook a bit longer to allow the mixture to reduce and thicken. Taste and adjust the seasoning to your liking.',
        'Step 3: Using a wooden spoon, make 6 indentations, or "wells," in the tomato mixture (make sure the indentations are spaced out). Gently crack an egg into each indention.',
      ],
    ),
       'Chocolate Chip Cookies': RecipeDetails(
      title: 'Chovolate Chip Cookies',
      ingredients: ['Butter', 'Eggs', 'Vamilla', 'Baking soda', 'Water', 'Salt', 'Flour', 'Chocolate chips'],
      instructions: [
        'Step 1: Beat the butter and sugars, then beat in the eggs and vanilla.',
        'Step 2: Dissolve the baking soda in hot water and add to the mixture.',
        'Step 3: Stir in the flour, chocolate chips, and walnuts.',
        'Step 4: Drop dough onto a prepared baking sheet.',
        'Step 5: Bake until the edges are golden brown.',

      ],
    ),
       'Simple Mashed Potatoes': RecipeDetails(
      title: 'Mashed Potatoes',
      ingredients: ['8 to 10 medium russet potatoes', '1 teaspoon salt', '2 tbspn butter', '1/4 cup hot milk'],
      instructions: [
        'Step 1: Place potatoes in large saucepan; add enough water to cover. Add 3/4 teaspoon of the salt. Bring to a boil. Reduce heat to medium-low; cover loosely and boil gently for 15 to 20 minutes or until potatoes break apart easily when pierced with fork. Drain well.',
        'Step 2: Return potatoes to saucepan; shake saucepan gently over low heat for 1 to 2 minutes to evaporate any excess moisture.',
        'Step 3: Mash potatoes with potato masher until no lumps remain. Add butter, pepper and remaining 1/4 teaspoon salt; continue mashing, gradually adding enough milk to make potatoes smooth and creamy.',
      ],
    ),
       'Best Banana Bread': RecipeDetails(
      title: 'Banana Bread',
      ingredients: ['1 Stick Butter', '3 Large Ripe Bananas', '2 Large Eggs', '1 tspn Vanilla Extract', '2 Cups All Purpose Flour', '1 Cup sugar', '1 tspn Baking Soda', '1/2 tspn Salt', '1/2 tspn Cinnamon'],
      instructions: [
        'Step 1: Preheat oven to 350 degrees. Spray a loaf pan with non-stick cooking spray or grease with butter and set aside. Add the stick of butter to a large bowl and microwave for 1 minute, or until melted.',
        'Step 2: Add the bananas to the same bowl and mash with a fork. Add the vanilla extract and egg to the bowl and use the same fork to mash and stir until no yellow streaks of egg remain.',
        'Step 3: In a second large bowl whisk together the flour, sugar, baking soda, salt, and cinnamon. Add the dry ingredients to the wet ingredients and mix together with a spatula just until combined.',
        'Step 4: Pour the batter into prepared loaf pan and bake for 45-55 minutes until a toothpick inserted in the center of the bread comes out clean.',
      ],
    ),
      
  
  };

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 103, 53),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: recipeDetails.keys.map((recipe) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      title: recipe,
                      details: recipeDetails[recipe]!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, 
                foregroundColor: Colors.white, 
                 
              ),
              child: Text(recipe),
            );
          }).toList(),
        ),
      ),
    );
  }
}
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key, required this.title, required this.details})
      : super(key: key);
  final String title;
  final RecipeDetails details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      backgroundColor: Colors.brown,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // recipe title style
            Text(
              details.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Ingredients list style
            const Text(
              'Ingredients:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details.ingredients.map((ingredient) {
                return Text(
                  '- $ingredient',
                  style: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Recipe instructions style
            const Text(
              'Instructions:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details.instructions.map((step) {
                return Text(
                  step,
                  style: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(title: 'HomeScreen'),
                  ),
                );
              },
              child: const Text('HomeScreen'),
            ),
          ],
        ),
      ),
    );
  }
}
