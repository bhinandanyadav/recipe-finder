/*
 * 🛠️ RECIPE SERVICE - API INTEGRATION
 * 
 * Purpose: Handles all recipe data fetching from external APIs and mock data
 * Location: lib/services/recipe_service.dart
 * 
 * What this file does:
 * - Connects to Edamam Recipe API to fetch real recipe data
 * - Provides fallback mock data when API fails or is unavailable
 * - Converts API response format to our app's Recipe model
 * - Handles API errors gracefully with fallback options
 * - Supports searching by ingredients or text queries
 * 
 * Why it's needed:
 * - Separates API logic from UI components (clean architecture)
 * - Provides single source of truth for recipe data
 * - Handles network errors and API failures
 * - Makes it easy to switch between real API and mock data
 * - Centralizes all recipe data fetching logic
 * 
 * Used by:
 * - recipe_provider.dart (for state management)
 * - Indirectly used by all screens that display recipes
 * 
 * API Used:
 * - Edamam Recipe API (https://developer.edamam.com/edamam-recipe-api)
 * - Provides comprehensive recipe data including nutrition info
 */

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  // Edamam API credentials - used to authenticate with the recipe API
  static const String appId = 'ab929034';
  static const String appKey = 'd5ff3d86a316402119824784a78b5092';
  static const String baseUrl = 'https://api.edamam.com/api/recipes/v2';

  // Search recipes by ingredients (e.g., ["chicken", "tomato"])
  Future<List<Recipe>> searchRecipesByIngredients(
    List<String> ingredients,
  ) async {
    try {
      final String ingredientsString = ingredients.join(
        ',',
      ); // Convert list to comma-separated string
      final Uri uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'type': 'public', // Use public recipes
          'q': ingredientsString, // Search query
          'app_id': appId, // API ID
          'app_key': appKey, // API key
          'random': 'true', // Get random results
        },
      );

      final response = await http.get(
        uri,
        headers: {'Edamam-Account-User': 'recipe_finder_user'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hits = data['hits'] ?? [];

        List<Recipe> recipes = [];
        for (var hit in hits) {
          final recipeData = hit['recipe'];
          if (recipeData != null) {
            final recipe = _parseRecipeFromEdamam(
              recipeData,
            ); // Convert API format to our format
            if (recipe != null) {
              recipes.add(recipe);
            }
          }
        }

        return recipes;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return _getMockRecipes(ingredients); // Use mock data if API fails
      }
    } catch (e) {
      print('Error fetching recipes: $e');
      return _getMockRecipes(ingredients); // Use mock data if network fails
    }
  }

  // Search recipes by text query (e.g., "chicken pasta")
  Future<List<Recipe>> searchRecipesByQuery(String query) async {
    try {
      final Uri uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'type': 'public', // Use public recipes
          'q': query, // Search query
          'app_id': appId, // API ID
          'app_key': appKey, // API key
          'random': 'true', // Get random results
        },
      );

      final response = await http.get(
        uri,
        headers: {'Edamam-Account-User': 'recipe_finder_user'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hits = data['hits'] ?? [];

        List<Recipe> recipes = [];
        for (var hit in hits) {
          final recipeData = hit['recipe'];
          if (recipeData != null) {
            final recipe = _parseRecipeFromEdamam(recipeData);
            if (recipe != null) {
              recipes.add(recipe);
            }
          }
        }

        return recipes;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return _getMockRecipes([query]);
      }
    } catch (e) {
      print('Error fetching recipes: $e');
      return _getMockRecipes([query]);
    }
  }

  Future<Recipe?> getRecipeDetails(String id) async {
    try {
      // For Edamam, we need to search by the recipe URL or title
      // Since Edamam doesn't provide direct recipe detail endpoint,
      // we'll return the recipe from our search results
      return null;
    } catch (e) {
      print('Error fetching recipe details: $e');
      return null;
    }
  }

  Recipe? _parseRecipeFromEdamam(Map<String, dynamic> recipeData) {
    try {
      final String title = recipeData['label'] ?? '';
      final String image = recipeData['image'] ?? '';
      final List<dynamic> ingredientLines = recipeData['ingredientLines'] ?? [];
      final int totalTime = (recipeData['totalTime'] is num) 
          ? (recipeData['totalTime'] as num).toInt() 
          : 0; // Safe conversion to int
      final int yield = (recipeData['yield'] is num) 
          ? (recipeData['yield'] as num).toInt() 
          : 1; // Safe conversion to int

      // Calculate calories from digest information
      double calories = 0.0;
      if (recipeData['digest'] != null) {
        for (var digest in recipeData['digest']) {
          if (digest['label'] == 'Calories') {
            calories = (digest['total'] as num).toDouble();
            break;
          }
        }
      }

      // Convert ingredient lines to ingredients list
      List<String> ingredients = ingredientLines
          .map((ingredient) => ingredient.toString())
          .toList();

      // Create a simple summary
      String summary =
          'A delicious recipe with ${ingredients.length} ingredients.';
      if (title.isNotEmpty) {
        summary =
            'Enjoy this $title with fresh ingredients and amazing flavors.';
      }

      return Recipe(
        id: DateTime.now().millisecondsSinceEpoch
            .toString(), // Generate unique ID
        title: title,
        image: image,
        ingredients: ingredients,
        instructions: _generateInstructions(
          ingredients,
        ), // Generate basic instructions
        readyInMinutes: totalTime,
        servings: yield,
        calories: calories,
        summary: summary,
      );
    } catch (e) {
      print('Error parsing recipe: $e');
      return null;
    }
  }

  List<String> _generateInstructions(List<String> ingredients) {
    // Generate basic cooking instructions based on ingredients
    List<String> instructions = [];

    instructions.add('Gather all the ingredients listed above.');
    instructions.add('Prepare your cooking equipment and workspace.');

    if (ingredients.any(
      (ingredient) => ingredient.toLowerCase().contains('chicken'),
    )) {
      instructions.add(
        'If using chicken, ensure it is properly cleaned and cut to desired size.',
      );
    }

    if (ingredients.any(
      (ingredient) => ingredient.toLowerCase().contains('vegetable'),
    )) {
      instructions.add('Wash and prepare all vegetables as needed.');
    }

    instructions.add('Follow the traditional cooking method for this dish.');
    instructions.add('Season to taste with salt and pepper.');
    instructions.add('Serve hot and enjoy your delicious meal!');

    return instructions;
  }

  // Fallback mock data for demo purposes
  List<Recipe> _getMockRecipes(List<String> ingredients) {
    return [
      Recipe(
        id: '1',
        title: 'Asian Chicken Stir Fry',
        image:
            'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
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
          'Cooked jasmine rice for serving',
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
          'Serve immediately over jasmine rice.',
        ],
        readyInMinutes: 25,
        servings: 4,
        calories: 385.0,
        summary:
            'A colorful and nutritious Asian-inspired stir fry with tender chicken and crisp vegetables.',
      ),
      Recipe(
        id: '2',
        title: 'Creamy Mushroom Pasta',
        image:
            'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400',
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
          'Extra Parmesan for serving',
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
          'Season with salt and pepper, garnish with parsley.',
        ],
        readyInMinutes: 30,
        servings: 4,
        calories: 520.0,
        summary:
            'Rich and creamy pasta with earthy mushrooms and aromatic herbs.',
      ),
    ];
  }
}
