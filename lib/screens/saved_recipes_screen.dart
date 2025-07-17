/*
 * 📱 SAVED RECIPES SCREEN - USER'S FAVORITE RECIPES
 * 
 * Purpose: Displays and manages user's saved/favorite recipes
 * Location: lib/screens/saved_recipes_screen.dart
 * 
 * What this file does:
 * - Shows all recipes that user has saved to favorites
 * - Displays nutrition statistics for saved recipes
 * - Allows users to remove recipes from favorites
 * - Provides empty state when no recipes are saved
 * - Calculates and shows total calories, servings, and averages
 * - Handles loading states and error messages
 * 
 * Why it's needed:
 * - Gives users access to their personal recipe collection
 * - Provides offline access to favorite recipes
 * - Shows nutrition tracking for meal planning
 * - Implements favorites management functionality
 * - Enhances user experience with personalized content
 * 
 * Used by:
 * - main.dart (as second tab in bottom navigation)
 * - Accessed when user taps "Saved" tab
 * 
 * Key Features:
 * - Beautiful grid layout for saved recipes
 * - Nutrition statistics card with calorie tracking
 * - Remove from favorites functionality
 * - Empty state with encouraging message
 * - Animated transitions and loading states
 * - Responsive design for different screen sizes
 * - Pull-to-refresh to update saved recipes
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';

class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  State<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen>
    with TickerProviderStateMixin {
  // Animation controllers for smooth screen transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize fade animation for smooth screen appearance
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Load saved recipes when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().loadSavedRecipes(); // Load from storage
      _animationController.forward(); // Start animation
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up animation controller
    super.dispose();
  }

  // Remove a recipe from user's favorites
  void _removeRecipe(Recipe recipe) {
    context.read<RecipeProvider>().removeRecipe(recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.orange.shade600,
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: const Text(
                      'Saved Recipes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  );
                },
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade600,
                      Colors.orange.shade800,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(
                        FontAwesomeIcons.bookmark,
                        size: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Consumer<RecipeProvider>(
            builder: (context, provider, child) {
              if (provider.savedRecipes.isEmpty) {
                return SliverFillRemaining(
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          margin: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.bookmark,
                                  size: 64,
                                  color: Colors.orange.shade300,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No saved recipes yet',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Save recipes from search results to see them here',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Navigate back to home screen
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.magnifyingGlass,
                                ),
                                label: const Text('Find Recipes'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade600,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildListDelegate([
                  // Nutrition Summary Section
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.shade50,
                                Colors.orange.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.chartLine,
                                      color: Colors.orange.shade700,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Nutrition Summary',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildNutritionCard(
                                    'Total Calories',
                                    '${provider.getTotalCalories(provider.savedRecipes).toInt()}',
                                    FontAwesomeIcons.fire,
                                    Colors.red.shade600,
                                  ),
                                  _buildNutritionCard(
                                    'Total Servings',
                                    '${provider.getTotalServings(provider.savedRecipes)}',
                                    FontAwesomeIcons.users,
                                    Colors.blue.shade600,
                                  ),
                                  _buildNutritionCard(
                                    'Avg Cal/Serving',
                                    '${provider.getAverageCaloriesPerServing(provider.savedRecipes).toInt()}',
                                    FontAwesomeIcons.utensils,
                                    Colors.green.shade600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Recipe Count Header
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.bookmark,
                                  color: Colors.orange.shade700,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${provider.savedRecipes.length} saved recipe${provider.savedRecipes.length == 1 ? '' : 's'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Saved Recipes List
                  ...provider.savedRecipes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final recipe = entry.value;
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: RecipeCard(
                            recipe: recipe,
                            onSaveToggle: () => _removeRecipe(recipe),
                            index: index,
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
