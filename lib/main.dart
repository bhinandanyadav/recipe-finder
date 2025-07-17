// Import statements - bringing in required Flutter and custom packages
import 'package:flutter/material.dart'; // Flutter's material design widgets
import 'package:provider/provider.dart'; // State management package
import 'providers/recipe_provider.dart'; // Custom provider for recipe data
import 'screens/home_screen.dart'; // Home screen widget
import 'screens/saved_recipes_screen.dart'; // Saved recipes screen widget

// Main function - Entry point of the Flutter application
void main() {
  runApp(const RecipeFinderApp()); // Starts the app with RecipeFinderApp widget
}

// Root widget of the application - Contains app configuration and state management
class RecipeFinderApp extends StatelessWidget {
  const RecipeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provider setup - Makes RecipeProvider available throughout the app
      create: (context) => RecipeProvider(),
      child: MaterialApp(
        title: 'Recipe Finder', // App title (appears in app switcher)
        debugShowCheckedModeBanner: false, // Removes debug banner in top-right
        theme: ThemeData(
          // App color scheme - Teal/blue theme colors
          primarySwatch:
              Colors.teal, // Fixed: Using MaterialColor instead of Color
          useMaterial3: true, // Uses Material Design 3 styling
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(
              249,
              35,
              103,
              124,
            ), // Main app color
            brightness: Brightness.light, // Light theme mode
          ),
          // App bar styling - Top navigation bar appearance
          appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(
              255,
              7,
              122,
              117,
            ), // Teal background
            foregroundColor: Colors.white, // White text/icons
            elevation: 0, // No shadow under app bar
            centerTitle: true, // Center the title
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Button styling - How elevated buttons look throughout the app
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600, // Orange background
              foregroundColor: Colors.white, // White text
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              elevation: 3, // Button shadow depth
            ),
          ),
          // Card styling - How recipe cards and containers look
          cardTheme: CardThemeData(
            elevation: 4, // Card shadow depth
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded card corners
            ),
          ),
          // Input field styling - How text fields and search boxes look
          inputDecorationTheme: InputDecorationTheme(
            filled: true, // Fill background
            fillColor: Colors.grey.shade100, // Light gray background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), // Rounded input corners
              borderSide: BorderSide.none, // No border line
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, // Left/right padding
              vertical: 15, // Top/bottom padding
            ),
          ),
        ),
        home: const MainNavigationScreen(), // First screen to show
      ),
    );
  }
}

// Main navigation screen - Handles bottom navigation between app screens
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

// State class for navigation screen - Manages screen switching and animations
class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  // Needed for animation controllers

  int _currentIndex = 0; // Currently selected bottom tab (0=Search, 1=Saved)
  late AnimationController _animationController; // Controls fade animations
  // ignore: unused_field
  late Animation<double>
  _fadeAnimation; // Fade animation for screen transitions

  // List of screens to display - corresponds to bottom navigation tabs
  final List<Widget> _screens = [
    const HomeScreen(), // Tab 0: Recipe search screen
    const SavedRecipesScreen(), // Tab 1: Saved recipes screen
  ];

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for smooth screen transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // 300ms animation duration
      vsync: this, // Animation ticker provider
    );
    // Create fade animation from transparent to opaque
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Clean up animation controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main screen content - Shows the currently selected screen
      body: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 300,
        ), // Smooth transition between screens
        child: _screens[_currentIndex], // Display screen based on selected tab
      ),

      // Bottom navigation bar - Two tabs: Search and Saved
      bottomNavigationBar: Container(
        // Shadow effect above the bottom navigation
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Light shadow
              blurRadius: 10, // Shadow blur amount
              offset: const Offset(0, -5), // Shadow position (above bar)
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex, // Which tab is selected
          onTap: (index) {
            // What happens when user taps a tab
            setState(() {
              _currentIndex = index; // Switch to selected tab
            });
            _animationController.reset(); // Reset animation
            _animationController.forward(); // Start animation for new screen
          },

          // Navigation bar styling
          type: BottomNavigationBarType.fixed, // Fixed positioning
          backgroundColor: Colors.white, // White background
          selectedItemColor:
              Colors.orange.shade600, // Orange color for selected tab
          unselectedItemColor:
              Colors.grey.shade400, // Gray color for unselected tabs
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold, // Bold text for selected tab
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0, // No shadow (we have custom shadow above)
          // Navigation items/tabs
          items: [
            // Tab 1: Search/Home screen
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ), // Animation for icon background
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 0
                      ? Colors
                            .orange
                            .shade100 // Light orange when selected
                      : Colors.transparent, // Transparent when not selected
                  borderRadius: BorderRadius.circular(12), // Rounded background
                ),
                child: Icon(
                  Icons.search,
                  size: _currentIndex == 0 ? 28 : 24,
                ), // Search icon
              ),
              label: 'Search',
            ),

            // Tab 2: Saved recipes screen
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ), // Animation for icon background
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 1
                      ? Colors
                            .orange
                            .shade100 // Light orange when selected
                      : Colors.transparent, // Transparent when not selected
                  borderRadius: BorderRadius.circular(12), // Rounded background
                ),
                child: Icon(
                  Icons.bookmark,
                  size: _currentIndex == 1 ? 28 : 24,
                ), // Bookmark icon
              ),
              label: 'Saved',
            ),
          ],
        ),
      ),
    );
  }
}
