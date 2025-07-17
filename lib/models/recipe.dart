/*
 * 📊 RECIPE DATA MODEL
 * 
 * Purpose: Defines the structure of a recipe object with all its properties
 * Location: lib/models/recipe.dart
 * 
 * What this file does:
 * - Defines Recipe class with all recipe properties (title, ingredients, etc.)
 * - Handles JSON serialization/deserialization for API responses
 * - Provides helper methods for parsing complex data structures
 * - Manages the 'saved' state for favorite recipes
 * 
 * Why it's needed:
 * - Ensures consistent data structure across the app
 * - Provides type safety when working with recipe data
 * - Handles conversion between API format and app format
 * - Makes code more maintainable and less error-prone
 * 
 * Used by:
 * - recipe_service.dart (for API data parsing)
 * - recipe_provider.dart (for state management)
 * - All screens that display recipe information
 * - storage_service.dart (for local storage)
 */

class Recipe {
  // Core recipe properties - these define what makes a recipe
  final String id; // Unique identifier for the recipe
  final String title; // Recipe name/title
  final String image; // URL to recipe image
  final List<String> ingredients; // List of ingredients needed
  final List<String> instructions; // Step-by-step cooking instructions
  final int readyInMinutes; // Total cooking time in minutes
  final int servings; // Number of servings this recipe makes
  final double calories; // Calorie count per serving
  final String summary; // Brief description of the recipe
  bool isSaved; // Whether user has saved this recipe

  // Constructor - creates a new Recipe instance with required properties
  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.ingredients,
    required this.instructions,
    required this.readyInMinutes,
    required this.servings,
    required this.calories,
    required this.summary,
    this.isSaved = false, // Default to not saved
  });

  // Factory constructor for creating Recipe from API JSON response
  // This handles the complex API format and converts it to our simple format
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'].toString(), // Convert ID to string
      title: json['title'] ?? '', // Use empty string if null
      image: json['image'] ?? '', // Use empty string if null
      ingredients: _parseIngredients(
        json['extendedIngredients'] ?? [],
      ), // Parse complex ingredients
      instructions: _parseInstructions(
        json['analyzedInstructions'] ?? [],
      ), // Parse complex instructions
      readyInMinutes: _safeToInt(json['readyInMinutes'], 0), // Safe conversion to int
      servings: _safeToInt(json['servings'], 1), // Safe conversion to int
      calories: _calculateCalories(
        json['nutrition'],
      ), // Extract calories from nutrition data
      summary: json['summary'] ?? '', // Use empty string if null
    );
  }

  // Helper method: Parses ingredients from API format to simple string list
  // API format: [{"original": "1 cup flour"}, {"original": "2 eggs"}]
  // Our format: ["1 cup flour", "2 eggs"]
  static List<String> _parseIngredients(List<dynamic> ingredients) {
    return ingredients
        .map((ingredient) => ingredient['original'].toString())
        .toList();
  }

  // Helper method: Parses instructions from API format to simple string list
  // API format: [{"steps": [{"step": "Heat oil"}, {"step": "Add ingredients"}]}]
  // Our format: ["Heat oil", "Add ingredients"]
  static List<String> _parseInstructions(List<dynamic> instructions) {
    List<String> steps = [];
    for (var instruction in instructions) {
      if (instruction['steps'] != null) {
        for (var step in instruction['steps']) {
          steps.add(step['step'].toString());
        }
      }
    }
    return steps;
  }

  // Helper method: Extracts calorie information from nutrition data
  // Searches through nutrition array to find calories and returns the amount
  static double _calculateCalories(Map<String, dynamic>? nutrition) {
    if (nutrition == null || nutrition['nutrients'] == null) return 0.0;

    for (var nutrient in nutrition['nutrients']) {
      if (nutrient['name'] == 'Calories') {
        return (nutrient['amount'] as num).toDouble();
      }
    }
    return 0.0;
  }

  // Helper method: Safely converts dynamic values to int
  // Handles both int and double values from API responses
  static int _safeToInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  // Helper method: Safely converts dynamic values to double
  // Handles both int and double values from API responses
  static double _safeToDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  // Converts Recipe object to JSON format for local storage
  // This is used when saving recipes to phone storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'ingredients': ingredients,
      'instructions': instructions,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'calories': calories,
      'summary': summary,
      'isSaved': isSaved,
    };
  }

  // Factory constructor for creating Recipe from saved JSON (local storage)
  // This is simpler than fromJson() because we already have clean data
  factory Recipe.fromSavedJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      ingredients: List<String>.from(
        json['ingredients'],
      ), // Convert back to string list
      instructions: List<String>.from(
        json['instructions'],
      ), // Convert back to string list
      readyInMinutes: _safeToInt(json['readyInMinutes'], 0), // Safe conversion to int
      servings: _safeToInt(json['servings'], 1), // Safe conversion to int
      calories: _safeToDouble(json['calories'], 0.0), // Safe conversion to double
      summary: json['summary'],
      isSaved: json['isSaved'] ?? false, // Default to false if missing
    );
  }
}
