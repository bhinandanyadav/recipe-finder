import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../services/storage_service.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();
  final StorageService _storageService = StorageService();

  List<Recipe> _recipes = [];
  List<Recipe> _savedRecipes = [];
  bool _isLoading = false;
  String _error = '';

  List<Recipe> get recipes => _recipes;
  List<Recipe> get savedRecipes => _savedRecipes;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> searchRecipes(List<String> ingredients) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _recipes = await _recipeService.searchRecipesByIngredients(ingredients);
      
      // Check which recipes are already saved
      for (Recipe recipe in _recipes) {
        recipe.isSaved = await _storageService.isRecipeSaved(recipe.id);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to search recipes: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveRecipe(Recipe recipe) async {
    try {
      await _storageService.saveRecipe(recipe);
      recipe.isSaved = true;
      
      // Update saved recipes list
      await loadSavedRecipes();
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save recipe: $e';
      notifyListeners();
    }
  }

  Future<void> removeRecipe(String recipeId) async {
    try {
      await _storageService.removeRecipe(recipeId);
      
      // Update the recipe in the main list
      final recipeIndex = _recipes.indexWhere((recipe) => recipe.id == recipeId);
      if (recipeIndex != -1) {
        _recipes[recipeIndex].isSaved = false;
      }
      
      // Update saved recipes list
      await loadSavedRecipes();
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to remove recipe: $e';
      notifyListeners();
    }
  }

  Future<void> loadSavedRecipes() async {
    try {
      _savedRecipes = await _storageService.getSavedRecipes();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load saved recipes: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  double getTotalCalories(List<Recipe> recipes) {
    return recipes.fold(0.0, (total, recipe) => total + recipe.calories);
  }

  int getTotalServings(List<Recipe> recipes) {
    return recipes.fold(0, (total, recipe) => total + recipe.servings);
  }

  double getAverageCaloriesPerServing(List<Recipe> recipes) {
    if (recipes.isEmpty) return 0.0;
    final totalCalories = getTotalCalories(recipes);
    final totalServings = getTotalServings(recipes);
    return totalServings > 0 ? totalCalories / totalServings : 0.0;
  }
}
