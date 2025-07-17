/*
 * 🧩 RECIPE CARD WIDGET - REUSABLE UI COMPONENT
 * 
 * Purpose: Displays recipe information in a beautiful, interactive card format
 * Location: lib/widgets/recipe_card.dart
 * 
 * What this file does:
 * - Creates visually appealing cards for recipe display
 * - Handles user interactions (tap to view details, save/unsave)
 * - Provides smooth animations and visual feedback
 * - Supports both search results and saved recipes display
 * - Includes image loading with shimmer effect
 * - Shows recipe metadata (time, servings, calories)
 * 
 * Why it's needed:
 * - Provides consistent recipe display across all screens
 * - Eliminates code duplication between different screens
 * - Centralized UI logic for recipe cards
 * - Ensures consistent user experience
 * - Easy to maintain and modify card appearance
 * 
 * Used by:
 * - home_screen.dart (for search results)
 * - saved_recipes_screen.dart (for saved recipes)
 * - Any screen that needs to display recipe lists
 * 
 * Features:
 * - Animated card interactions (scale on hover/tap)
 * - Cached network images with loading states
 * - Save/unsave functionality with heart icon
 * - Nutrition and timing information display
 * - Staggered animations for list appearance
 * - Responsive design for different screen sizes
 */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import '../models/recipe.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe; // Recipe data to display
  final VoidCallback? onSaveToggle; // Callback when save button is tapped
  final int index; // Index in list (for staggered animations)

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onSaveToggle,
    required this.index,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with SingleTickerProviderStateMixin {
  // Animation controllers for smooth card interactions
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation; // Scale animation for tap feedback
  // ignore: unused_field
  late Animation<double> _fadeAnimation; // Fade animation for appearance
  // ignore: unused_field, prefer_final_fields
  bool _isHovered = false; // Track hover state for web/desktop

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with 300ms duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Create scale animation (grows slightly when tapped)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    // Create fade animation (appears smoothly)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up animation controller
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    RecipeDetailScreen(recipe: widget.recipe),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        );
                      },
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: _onTapCancel,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.grey.shade50],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Recipe Image with Overlay
                            _buildImageSection(),

                            // Recipe Info
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and Save Button
                                  _buildTitleSection(),

                                  const SizedBox(height: 12),

                                  // Recipe Stats
                                  _buildStatsSection(),

                                  const SizedBox(height: 12),

                                  // Summary
                                  _buildSummarySection(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade100, Colors.orange.shade200],
        ),
      ),
      child: Stack(
        children: [
          // Recipe Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: widget.recipe.image.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.recipe.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    placeholder: (context, url) => _buildShimmerPlaceholder(),
                    errorWidget: (context, url, error) =>
                        _buildPlaceholderImage(),
                  )
                : _buildPlaceholderImage(),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
              ),
            ),
          ),

          // Save Button
          if (widget.onSaveToggle != null)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.recipe.isSaved
                          ? Icons.favorite
                          : Icons.favorite_border,
                      key: ValueKey(widget.recipe.isSaved),
                      color: widget.recipe.isSaved
                          ? Colors.red
                          : Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  onPressed: widget.onSaveToggle,
                ),
              ),
            ),

          // Time Badge
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade600,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.recipe.readyInMinutes} min',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.recipe.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.people,
          value: '${widget.recipe.servings}',
          label: 'servings',
        ),
        const SizedBox(width: 20),
        _buildStatItem(
          icon: Icons.local_fire_department,
          value: '${widget.recipe.calories.toInt()}',
          label: 'cal',
        ),
        const SizedBox(width: 20),
        _buildStatItem(
          icon: Icons.restaurant_menu,
          value: '${widget.recipe.ingredients.length}',
          label: 'ingredients',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: Colors.orange.shade700),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Text(
      widget.recipe.summary.replaceAll(RegExp(r'<[^>]*>'), ''),
      style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.4),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.white),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange.shade200, Colors.orange.shade300],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 48, color: Colors.orange.shade600),
            const SizedBox(height: 8),
            Text(
              'Recipe Image',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
