/*
 * 💾 STORAGE SERVICE - LOCAL DATA PERSISTENCE
 * 
 * Purpose: Handles saving and loading user's favorite recipes to/from device storage
 * Location: lib/services/storage_service.dart
 * 
 * What this file does:
 * - Saves user's favorite recipes to device storage (persists between app sessions)
 * - Loads saved recipes when app starts
 * - Removes recipes from favorites when user unsaves them
 * - Checks if a recipe is already saved
 * - Manages all local storage operations using SharedPreferences
 * 
 * Why it's needed:
 * - Allows users to save recipes for offline access
 * - Persists user data between app sessions
 * - Works offline (no internet required for saved recipes)
 * - Separates storage logic from UI components
 * - Provides simple interface for recipe persistence
 * 
 * Used by:
 * - recipe_provider.dart (for managing saved recipes state)
 * - Indirectly used by saved_recipes_screen.dart
 * 
 * Storage Technology:
 * - Uses SharedPreferences (simple key-value storage)
 * - Stores recipes as JSON strings
 * - Automatically handles serialization/deserialization
 */

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class StorageService {
  // Key used to store recipes in SharedPreferences
  static const String _savedRecipesKey = 'saved_recipes';

  // Save a recipe to user's favorites
  Future<void> saveRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance(); // Get storage instance
    final savedRecipes = await getSavedRecipes(); // Get existing saved recipes

    recipe.isSaved = true; // Mark recipe as saved
    savedRecipes.add(recipe); // Add to saved list

    // Convert recipes to JSON format and save to storage
    final encodedRecipes = savedRecipes
        .map((recipe) => recipe.toJson())
        .toList();
    await prefs.setString(_savedRecipesKey, json.encode(encodedRecipes));
  }

  // Remove a recipe from user's favorites
  Future<void> removeRecipe(String recipeId) async {
    final prefs = await SharedPreferences.getInstance(); // Get storage instance
    final savedRecipes = await getSavedRecipes(); // Get existing saved recipes

    // Remove recipe with matching ID
    savedRecipes.removeWhere((recipe) => recipe.id == recipeId);

    // Convert remaining recipes to JSON format and save to storage
    final encodedRecipes = savedRecipes
        .map((recipe) => recipe.toJson())
        .toList();
    await prefs.setString(_savedRecipesKey, json.encode(encodedRecipes));
  }

  // Load all saved recipes from storage
  Future<List<Recipe>> getSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance(); // Get storage instance
    final savedRecipesString = prefs.getString(
      _savedRecipesKey,
    ); // Get stored JSON string

    if (savedRecipesString == null) {
      return []; // Return empty list if no saved recipes
    }

    // Convert JSON string back to Recipe objects
    final List<dynamic> decodedRecipes = json.decode(savedRecipesString);
    return decodedRecipes
        .map((recipeJson) => Recipe.fromSavedJson(recipeJson))
        .toList();
  }

  // Check if a specific recipe is already saved
  Future<bool> isRecipeSaved(String recipeId) async {
    final savedRecipes = await getSavedRecipes(); // Get all saved recipes
    return savedRecipes.any(
      (recipe) => recipe.id == recipeId,
    ); // Check if ID exists
  }

  // Clear all saved recipes (useful for testing or reset functionality)
  Future<void> clearAllSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance(); // Get storage instance
    await prefs.remove(_savedRecipesKey); // Remove the stored data
  }
}
