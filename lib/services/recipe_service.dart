import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  // Note: For this demo, we'll use a mock API response
  // In a real app, you would use an actual API like Spoonacular
  // Replace with your actual API key: 'YOUR_API_KEY_HERE'
  static const String apiKey = 'DEMO_API_KEY';
  static const String baseUrl = 'https://api.spoonacular.com/recipes';

  Future<List<Recipe>> searchRecipesByIngredients(List<String> ingredients) async {
    try {
      // For demo purposes, we'll return mock data
      // In a real implementation, uncomment the HTTP request below
      
      /*
      final String ingredientsString = ingredients.join(',');
      final Uri uri = Uri.parse('$baseUrl/findByIngredients')
          .replace(queryParameters: {
        'ingredients': ingredientsString,
        'number': '10',
        'apiKey': apiKey,
      });

      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Recipe> recipes = [];
        
        for (var recipeData in data) {
          final detailResponse = await getRecipeDetails(recipeData['id'].toString());
          if (detailResponse != null) {
            recipes.add(detailResponse);
          }
        }
        
        return recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
      */

      // Mock data for demo
      return _getMockRecipes(ingredients);
    } catch (e) {
      print('Error fetching recipes: $e');
      return [];
    }
  }

  Future<Recipe?> getRecipeDetails(String id) async {
    try {
      // For demo purposes, we'll return mock data
      // In a real implementation, uncomment the HTTP request below
      
      /*
      final Uri uri = Uri.parse('$baseUrl/$id/information')
          .replace(queryParameters: {
        'includeNutrition': 'true',
        'apiKey': apiKey,
      });

      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Recipe.fromJson(data);
      } else {
        throw Exception('Failed to load recipe details');
      }
      */

      // Return mock data for demo
      return _getMockRecipeDetail(id);
    } catch (e) {
      print('Error fetching recipe details: $e');
      return null;
    }
  }

  List<Recipe> _getMockRecipes(List<String> ingredients) {
    // Mock recipes - always return a good variety of recipes
    List<Recipe> mockRecipes = [];
    
    // Comprehensive collection of recipes with detailed ingredients
    mockRecipes.addAll([
      Recipe(
        id: '1',
        title: 'Asian Chicken Stir Fry',
        image: '',
        ingredients: [
          '1 lb boneless chicken breast, cut into strips',
          '2 cups broccoli florets',
          '1 red bell pepper, sliced',
          '1 cup snap peas',
          '2 carrots, julienned',
          '3 cloves garlic, minced',
          '1 tbsp fresh ginger, grated',
          '3 tbsp soy sauce',
          '2 tbsp oyster sauce',
          '1 tbsp cornstarch',
          '2 tbsp vegetable oil',
          '1 tsp sesame oil',
          '2 green onions, chopped',
          'Cooked jasmine rice for serving'
        ],
        instructions: [
          'Mix soy sauce, oyster sauce, and cornstarch in a small bowl.',
          'Heat vegetable oil in a large wok or skillet over high heat.',
          'Add chicken strips and cook for 5-6 minutes until golden.',
          'Add garlic and ginger, stir for 30 seconds.',
          'Add broccoli, bell pepper, carrots, and snap peas.',
          'Stir-fry for 4-5 minutes until vegetables are crisp-tender.',
          'Pour sauce over and toss to coat everything.',
          'Drizzle with sesame oil and garnish with green onions.',
          'Serve immediately over jasmine rice.'
        ],
        readyInMinutes: 25,
        servings: 4,
        calories: 385.0,
        summary: 'A colorful and nutritious Asian-inspired stir fry with tender chicken and crisp vegetables.',
      ),
      Recipe(
        id: '2',
        title: 'Creamy Mushroom Pasta',
        image: '',
        ingredients: [
          '12 oz fettuccine pasta',
          '1 lb mixed mushrooms (cremini, shiitake, button), sliced',
          '1 cup heavy cream',
          '1/2 cup white wine (optional)',
          '1/2 cup grated Parmesan cheese',
          '4 cloves garlic, minced',
          '1 medium onion, diced',
          '3 tbsp butter',
          '2 tbsp olive oil',
          '1/4 cup fresh parsley, chopped',
          '1/2 tsp dried thyme',
          'Salt and black pepper to taste',
          'Extra Parmesan for serving'
        ],
        instructions: [
          'Cook pasta according to package directions. Reserve 1 cup pasta water.',
          'Heat olive oil and 1 tbsp butter in a large skillet.',
          'Add onions and cook until translucent, about 5 minutes.',
          'Add mushrooms and cook until golden brown, 8-10 minutes.',
          'Add garlic and thyme, cook for 1 minute.',
          'Pour in wine (if using) and let it reduce by half.',
          'Add cream and bring to a gentle simmer.',
          'Stir in remaining butter and Parmesan cheese.',
          'Add cooked pasta and toss with sauce.',
          'Add pasta water if needed for consistency.',
          'Season with salt and pepper, garnish with parsley.'
        ],
        readyInMinutes: 30,
        servings: 4,
        calories: 520.0,
        summary: 'Rich and creamy pasta with earthy mushrooms and aromatic herbs.',
      ),
      Recipe(
        id: '3',
        title: 'Loaded Beef Tacos',
        image: '',
        ingredients: [
          '1.5 lbs ground beef (80/20)',
          '12 corn tortillas',
          '1 packet taco seasoning',
          '1 cup sharp cheddar cheese, shredded',
          '1 cup Mexican cheese blend',
          '2 cups iceberg lettuce, shredded',
          '3 Roma tomatoes, diced',
          '1 white onion, finely diced',
          '1 cup sour cream',
          '1 cup guacamole',
          '1/2 cup fresh cilantro, chopped',
          '2 limes, cut into wedges',
          'Hot sauce for serving'
        ],
        instructions: [
          'Brown ground beef in a large skillet over medium-high heat.',
          'Drain excess fat and add taco seasoning with 3/4 cup water.',
          'Simmer for 5-7 minutes until sauce thickens.',
          'Warm tortillas in a dry skillet or microwave.',
          'Set up a taco bar with all toppings in separate bowls.',
          'Fill each tortilla with beef mixture.',
          'Top with cheese, lettuce, tomatoes, onions, and cilantro.',
          'Serve with sour cream, guacamole, lime wedges, and hot sauce.'
        ],
        readyInMinutes: 25,
        servings: 6,
        calories: 445.0,
        summary: 'Ultimate loaded tacos with all your favorite toppings for a family-friendly meal.',
      ),
      Recipe(
        id: '4',
        title: 'Hearty Minestrone Soup',
        image: '',
        ingredients: [
          '6 cups vegetable broth',
          '1 can (28 oz) diced tomatoes',
          '2 cups kidney beans, drained and rinsed',
          '1 cup cannellini beans, drained and rinsed',
          '2 carrots, diced',
          '2 celery stalks, diced',
          '1 zucchini, diced',
          '1 yellow onion, diced',
          '4 cloves garlic, minced',
          '1 cup small pasta (ditalini or elbow)',
          '2 tbsp olive oil',
          '2 tsp dried basil',
          '1 tsp dried oregano',
          'Fresh basil for garnish',
          'Grated Parmesan for serving'
        ],
        instructions: [
          'Heat olive oil in a large pot over medium heat.',
          'Add onion, carrots, and celery. Cook for 8-10 minutes.',
          'Add garlic, basil, and oregano. Cook for 1 minute.',
          'Add diced tomatoes, broth, and both types of beans.',
          'Bring to a boil, then reduce heat and simmer for 20 minutes.',
          'Add zucchini and pasta. Cook for 10-12 minutes.',
          'Season with salt and pepper to taste.',
          'Serve hot with fresh basil and Parmesan cheese.'
        ],
        readyInMinutes: 45,
        servings: 6,
        calories: 285.0,
        summary: 'A hearty Italian vegetable soup loaded with beans, pasta, and fresh herbs.',
      ),
      Recipe(
        id: '5',
        title: 'Greek Quinoa Salad',
        image: '',
        ingredients: [
          '1.5 cups quinoa, rinsed',
          '3 cups water or vegetable broth',
          '1 large cucumber, diced',
          '2 cups cherry tomatoes, halved',
          '1 cup kalamata olives, pitted and halved',
          '1 cup crumbled feta cheese',
          '1/2 red onion, thinly sliced',
          '1/4 cup fresh dill, chopped',
          '1/4 cup fresh mint, chopped',
          'Dressing: 1/3 cup extra virgin olive oil',
          '3 tbsp fresh lemon juice',
          '2 cloves garlic, minced',
          '1 tsp dried oregano',
          'Salt and pepper to taste'
        ],
        instructions: [
          'Cook quinoa with water or broth according to package directions.',
          'Let quinoa cool completely in a large bowl.',
          'Add cucumber, tomatoes, olives, feta, onion, dill, and mint.',
          'In a small bowl, whisk together olive oil, lemon juice, garlic, and oregano.',
          'Pour dressing over salad and toss gently to combine.',
          'Season with salt and pepper.',
          'Chill for at least 30 minutes before serving.',
          'Can be made up to 2 days ahead.'
        ],
        readyInMinutes: 35,
        servings: 6,
        calories: 340.0,
        summary: 'A refreshing Mediterranean quinoa salad packed with fresh herbs and tangy feta.',
      ),
      Recipe(
        id: '6',
        title: 'Buttermilk Pancakes',
        image: '',
        ingredients: [
          '2 cups all-purpose flour',
          '3 large eggs',
          '2 cups buttermilk',
          '1/4 cup granulated sugar',
          '1 tsp baking soda',
          '1 tsp baking powder',
          '1/2 tsp salt',
          '4 tbsp unsalted butter, melted',
          '1 tsp vanilla extract',
          'Butter for cooking',
          'Maple syrup and fresh berries for serving'
        ],
        instructions: [
          'In a large bowl, whisk together flour, sugar, baking soda, baking powder, and salt.',
          'In another bowl, whisk together eggs, buttermilk, melted butter, and vanilla.',
          'Pour wet ingredients into dry ingredients and stir until just combined.',
          'Let batter rest for 5 minutes (it should be slightly lumpy).',
          'Heat a griddle or large skillet over medium heat and butter lightly.',
          'Pour 1/4 cup batter for each pancake.',
          'Cook until bubbles form on surface and edges look set, about 2-3 minutes.',
          'Flip and cook until golden brown, 1-2 minutes more.',
          'Serve immediately with butter, maple syrup, and fresh berries.'
        ],
        readyInMinutes: 20,
        servings: 4,
        calories: 380.0,
        summary: 'Fluffy, tangy buttermilk pancakes that are perfect for weekend breakfast.',
      ),
      Recipe(
        id: '7',
        title: 'Classic Spaghetti Carbonara',
        image: '',
        ingredients: [
          '1 lb spaghetti',
          '6 oz pancetta or bacon, diced',
          '4 large egg yolks',
          '1 whole egg',
          '1 cup Pecorino Romano cheese, grated',
          '4 cloves garlic, minced',
          '1/4 cup dry white wine (optional)',
          'Freshly ground black pepper',
          'Salt for pasta water',
          'Fresh parsley for garnish'
        ],
        instructions: [
          'Bring a large pot of salted water to boil for pasta.',
          'In a large bowl, whisk together egg yolks, whole egg, and cheese.',
          'Cook pancetta in a large skillet until crispy, about 5-7 minutes.',
          'Add garlic and cook for 1 minute. Add wine if using.',
          'Cook spaghetti according to package directions until al dente.',
          'Reserve 1 cup pasta cooking water before draining.',
          'Add hot pasta to the skillet with pancetta.',
          'Remove from heat and quickly stir in egg mixture.',
          'Add pasta water gradually until sauce is creamy.',
          'Season generously with black pepper and serve immediately.'
        ],
        readyInMinutes: 25,
        servings: 4,
        calories: 580.0,
        summary: 'An authentic Roman pasta dish with a silky egg-based sauce and crispy pancetta.',
      ),
      Recipe(
        id: '8',
        title: 'Herb-Crusted Salmon',
        image: '',
        ingredients: [
          '4 salmon fillets (6 oz each)',
          '1/2 cup panko breadcrumbs',
          '1/4 cup fresh parsley, chopped',
          '2 tbsp fresh dill, chopped',
          '2 tbsp fresh chives, chopped',
          '3 cloves garlic, minced',
          '3 tbsp olive oil',
          '2 tbsp Dijon mustard',
          '1 lemon, zested and juiced',
          'Salt and pepper to taste',
          'Lemon wedges for serving'
        ],
        instructions: [
          'Preheat oven to 400°F (200°C).',
          'Mix breadcrumbs, herbs, garlic, 2 tbsp olive oil, and lemon zest.',
          'Season salmon fillets with salt and pepper.',
          'Brush tops with Dijon mustard.',
          'Press herb mixture onto the mustard-coated side.',
          'Heat remaining oil in an oven-safe skillet.',
          'Sear salmon herb-side up for 3-4 minutes.',
          'Transfer skillet to oven and bake for 8-10 minutes.',
          'Drizzle with lemon juice before serving.',
          'Serve with lemon wedges and your favorite sides.'
        ],
        readyInMinutes: 20,
        servings: 4,
        calories: 420.0,
        summary: 'Perfectly cooked salmon with a crispy herb crust and bright lemon flavor.',
      ),
      Recipe(
        id: '9',
        title: 'Chicken Tikka Masala',
        image: '',
        ingredients: [
          '2 lbs boneless chicken thighs, cut into chunks',
          '1 cup plain Greek yogurt',
          '2 tbsp garam masala',
          '1 tbsp ground cumin',
          '1 tbsp paprika',
          '4 cloves garlic, minced',
          '1 inch ginger, grated',
          '1 large onion, diced',
          '1 can (28 oz) crushed tomatoes',
          '1 cup heavy cream',
          '2 tbsp tomato paste',
          '2 tbsp vegetable oil',
          'Fresh cilantro for garnish',
          'Basmati rice for serving',
          'Salt to taste'
        ],
        instructions: [
          'Marinate chicken in yogurt, half the spices, garlic, and ginger for 30 minutes.',
          'Heat oil in a large skillet and cook marinated chicken until done.',
          'Remove chicken and set aside.',
          'In the same pan, cook onions until golden.',
          'Add remaining spices and tomato paste, cook for 1 minute.',
          'Add crushed tomatoes and simmer for 15 minutes.',
          'Stir in cream and return chicken to the pan.',
          'Simmer for 10 minutes until sauce thickens.',
          'Garnish with cilantro and serve over basmati rice.'
        ],
        readyInMinutes: 60,
        servings: 6,
        calories: 485.0,
        summary: 'Rich and creamy Indian curry with tender chicken in a spiced tomato sauce.',
      ),
      Recipe(
        id: '10',
        title: 'Chocolate Chip Cookies',
        image: '',
        ingredients: [
          '2 1/4 cups all-purpose flour',
          '1 cup butter, softened',
          '3/4 cup granulated sugar',
          '3/4 cup brown sugar, packed',
          '2 large eggs',
          '2 tsp vanilla extract',
          '1 tsp baking soda',
          '1 tsp salt',
          '2 cups chocolate chips',
          '1 cup chopped walnuts (optional)'
        ],
        instructions: [
          'Preheat oven to 375°F (190°C).',
          'Cream together butter and both sugars until light and fluffy.',
          'Beat in eggs one at a time, then vanilla.',
          'In a separate bowl, whisk flour, baking soda, and salt.',
          'Gradually mix dry ingredients into wet ingredients.',
          'Stir in chocolate chips and nuts if using.',
          'Drop rounded tablespoons of dough onto ungreased baking sheets.',
          'Bake for 9-11 minutes until golden brown.',
          'Cool on baking sheet for 2 minutes before transferring to a wire rack.'
        ],
        readyInMinutes: 25,
        servings: 36,
        calories: 140.0,
        summary: 'Classic homemade chocolate chip cookies that are crispy on the edges and chewy in the center.',
      ),
    ]);
    
    // Filter recipes based on ingredients if any specific ones are mentioned
    if (ingredients.isNotEmpty) {
      List<Recipe> filteredRecipes = [];
      
      for (String ingredient in ingredients) {
        String lowerIngredient = ingredient.toLowerCase();
        
        // Add recipes that match the ingredients
        if (lowerIngredient.contains('chicken')) {
          filteredRecipes.add(mockRecipes[0]); // Chicken Stir Fry
        }
        if (lowerIngredient.contains('pasta')) {
          filteredRecipes.add(mockRecipes[1]); // Pasta Primavera
        }
        if (lowerIngredient.contains('beef')) {
          filteredRecipes.add(mockRecipes[2]); // Beef Tacos
        }
        if (lowerIngredient.contains('vegetable') || lowerIngredient.contains('tomato')) {
          filteredRecipes.add(mockRecipes[3]); // Vegetable Soup
        }
        if (lowerIngredient.contains('lettuce') || lowerIngredient.contains('salad')) {
          filteredRecipes.add(mockRecipes[4]); // Mediterranean Salad
        }
        if (lowerIngredient.contains('flour') || lowerIngredient.contains('egg') || lowerIngredient.contains('milk')) {
          filteredRecipes.add(mockRecipes[5]); // Pancakes
        }
      }
      
      // Remove duplicates and return filtered recipes, or all recipes if no matches
      if (filteredRecipes.isNotEmpty) {
        return filteredRecipes.toSet().toList();
      }
    }
    
    // Return all recipes if no specific ingredients match
    return mockRecipes;
  }

  Recipe? _getMockRecipeDetail(String id) {
    // Return more detailed mock data based on ID
    switch (id) {
      case '1':
        return Recipe(
          id: '1',
          title: 'Chicken Stir Fry',
          image: 'https://example.com/chicken-stir-fry.jpg',
          ingredients: [
            '1 lb chicken breast, cubed',
            '2 cups mixed vegetables',
            '2 tbsp soy sauce',
            '1 tbsp oil',
            '1 tsp garlic powder'
          ],
          instructions: [
            'Heat oil in a large pan over medium-high heat',
            'Add chicken and cook until golden brown',
            'Add vegetables and stir-fry for 3-4 minutes',
            'Add soy sauce and garlic powder',
            'Serve over rice'
          ],
          readyInMinutes: 20,
          servings: 4,
          calories: 325.0,
          summary: 'A quick and healthy chicken stir fry perfect for busy weeknights.',
        );
      default:
        return null;
    }
  }
}
