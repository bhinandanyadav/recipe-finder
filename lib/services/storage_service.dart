import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class StorageService {
  static const String _savedRecipesKey = 'saved_recipes';

  Future<void> saveRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRecipes = await getSavedRecipes();
    
    recipe.isSaved = true;
    savedRecipes.add(recipe);
    
    final encodedRecipes = savedRecipes.map((recipe) => recipe.toJson()).toList();
    await prefs.setString(_savedRecipesKey, json.encode(encodedRecipes));
  }

  Future<void> removeRecipe(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRecipes = await getSavedRecipes();
    
    savedRecipes.removeWhere((recipe) => recipe.id == recipeId);
    
    final encodedRecipes = savedRecipes.map((recipe) => recipe.toJson()).toList();
    await prefs.setString(_savedRecipesKey, json.encode(encodedRecipes));
  }

  Future<List<Recipe>> getSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRecipesString = prefs.getString(_savedRecipesKey);
    
    if (savedRecipesString == null) {
      return [];
    }
    
    final List<dynamic> decodedRecipes = json.decode(savedRecipesString);
    return decodedRecipes.map((recipeJson) => Recipe.fromSavedJson(recipeJson)).toList();
  }

  Future<bool> isRecipeSaved(String recipeId) async {
    final savedRecipes = await getSavedRecipes();
    return savedRecipes.any((recipe) => recipe.id == recipeId);
  }

  Future<void> clearAllSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedRecipesKey);
  }
}
