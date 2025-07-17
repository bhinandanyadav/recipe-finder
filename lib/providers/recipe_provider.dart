/*
 * 🔄 RECIPE PROVIDER - STATE MANAGEMENT
 * 
 * Purpose: Manages global state for recipes, search results, and user favorites
 * Location: lib/providers/recipe_provider.dart
 * 
 * What this file does:
 * - Manages recipe search results and loading states
 * - Handles saving/removing favorite recipes
 * - Provides nutrition calculations and filtering
 * - Coordinates between UI and services (API & Storage)
 * - Notifies UI when data changes (reactive programming)
 * 
 * Why it's needed:
 * - Centralizes recipe data management across all screens
 * - Eliminates prop drilling (passing data through widget tree)
 * - Provides reactive UI updates when data changes
 * - Separates business logic from UI components
 * 
 * Used by:
 * - All screens that display or modify recipe data
 * - main.dart (provides this to entire app)
 * - Any widget that needs access to recipe state
 * 
 * Key Features:
 * - Search recipes by ingredients or query
 * - Save/unsave favorite recipes
 * - Calculate nutrition statistics
 * - Filter recipes by time, calories, servings
 * - Loading states and error handling
 */

import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../services/storage_service.dart';

class RecipeProvider extends ChangeNotifier {
  // Service instances for API calls and local storage
  final RecipeService _recipeService = RecipeService(); // Handles API calls
  final StorageService _storageService =
      StorageService(); // Handles local storage

  // Private state variables (underscore makes them private)
  List<Recipe> _recipes = []; // Current search results
  List<Recipe> _savedRecipes = []; // User's saved/favorite recipes
  bool _isLoading = false; // Whether app is loading data
  String _error = ''; // Error message to display
  String _lastSearchQuery = ''; // Last search term used

  // Public getters - These allow other parts of app to read state
  List<Recipe> get recipes => _recipes;
  List<Recipe> get savedRecipes => _savedRecipes;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get lastSearchQuery => _lastSearchQuery;

  // SEARCH FUNCTIONALITY

  // Search recipes by ingredients (e.g., ["chicken", "tomato"])
  Future<void> searchRecipes(List<String> ingredients) async {
    _isLoading = true; // Show loading indicator
    _error = ''; // Clear previous errors
    _lastSearchQuery = ingredients.join(', '); // Save search query
    notifyListeners(); // Update UI

    try {
      // Call API to get recipes
      _recipes = await _recipeService.searchRecipesByIngredients(ingredients);

      // Check which recipes are already saved by user
      for (Recipe recipe in _recipes) {
        recipe.isSaved = await _storageService.isRecipeSaved(recipe.id);
      }

      _isLoading = false; // Hide loading indicator
      notifyListeners(); // Update UI with results
    } catch (e) {
      _error = 'Failed to search recipes: $e'; // Set error message
      _isLoading = false; // Hide loading indicator
      notifyListeners(); // Update UI to show error
    }
  }

  // Search recipes by text query (e.g., "chicken pasta")
  Future<void> searchRecipesByQuery(String query) async {
    if (query.trim().isEmpty) return; // Don't search if query is empty

    _isLoading = true; // Show loading indicator
    _error = ''; // Clear previous errors
    _lastSearchQuery = query; // Save search query
    notifyListeners(); // Update UI

    try {
      // Call API to get recipes
      _recipes = await _recipeService.searchRecipesByQuery(query);

      // Check which recipes are already saved by user
      for (Recipe recipe in _recipes) {
        recipe.isSaved = await _storageService.isRecipeSaved(recipe.id);
      }

      _isLoading = false; // Hide loading indicator
      notifyListeners(); // Update UI with results
    } catch (e) {
      _error = 'Failed to search recipes: $e'; // Set error message
      _isLoading = false; // Hide loading indicator
      notifyListeners(); // Update UI to show error
    }
  }

  // FAVORITE RECIPES FUNCTIONALITY

  // Save a recipe to user's favorites
  Future<void> saveRecipe(Recipe recipe) async {
    try {
      await _storageService.saveRecipe(recipe); // Save to local storage
      recipe.isSaved = true; // Mark as saved

      // Update saved recipes list to include new recipe
      await loadSavedRecipes();

      notifyListeners(); // Update UI
    } catch (e) {
      _error = 'Failed to save recipe: $e'; // Set error message
      notifyListeners(); // Update UI to show error
    }
  }

  // Remove a recipe from user's favorites
  Future<void> removeRecipe(String recipeId) async {
    try {
      await _storageService.removeRecipe(recipeId); // Remove from local storage

      // Update the recipe in the main search results list
      final recipeIndex = _recipes.indexWhere(
        (recipe) => recipe.id == recipeId,
      );
      if (recipeIndex != -1) {
        _recipes[recipeIndex].isSaved = false; // Mark as not saved
      }

      // Update saved recipes list to remove the recipe
      await loadSavedRecipes();

      notifyListeners(); // Update UI
    } catch (e) {
      _error = 'Failed to remove recipe: $e'; // Set error message
      notifyListeners(); // Update UI to show error
    }
  }

  // Load all saved recipes from local storage
  Future<void> loadSavedRecipes() async {
    try {
      _savedRecipes = await _storageService.getSavedRecipes();
      notifyListeners(); // Update UI
    } catch (e) {
      _error = 'Failed to load saved recipes: $e'; // Set error message
      notifyListeners(); // Update UI to show error
    }
  }

  // UTILITY METHODS

  // Clear any error messages
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Clear current search results
  void clearRecipes() {
    _recipes = [];
    _lastSearchQuery = '';
    notifyListeners();
  }

  // NUTRITION CALCULATION METHODS

  // Calculate total calories for a list of recipes
  double getTotalCalories(List<Recipe> recipes) {
    return recipes.fold(0.0, (total, recipe) => total + recipe.calories);
  }

  // Calculate total servings for a list of recipes
  int getTotalServings(List<Recipe> recipes) {
    return recipes.fold(0, (total, recipe) => total + recipe.servings);
  }

  // Calculate average calories per serving across recipes
  double getAverageCaloriesPerServing(List<Recipe> recipes) {
    if (recipes.isEmpty) return 0.0;
    final totalCalories = getTotalCalories(recipes);
    final totalServings = getTotalServings(recipes);
    return totalServings > 0 ? totalCalories / totalServings : 0.0;
  }

  // FILTERING METHODS

  // Filter recipes based on time, calories, and servings
  List<Recipe> getFilteredRecipes({
    int? maxTime, // Maximum cooking time in minutes
    double? maxCalories, // Maximum calories per serving
    int? minServings, // Minimum number of servings
  }) {
    return _recipes.where((recipe) {
      if (maxTime != null && recipe.readyInMinutes > maxTime) return false;
      if (maxCalories != null && recipe.calories > maxCalories) return false;
      if (minServings != null && recipe.servings < minServings) return false;
      return true;
    }).toList();
  }
}
