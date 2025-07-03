# 🍽️ Recipe Finder

**A Flutter app that helps you discover delicious recipes based on your available ingredients!**

![Flutter](https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-Language-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android%20%7C%20iOS%20%7C%20Desktop-green)

## 🌟 Features

### Core Functionality
- 🔍 **Smart Ingredient Search**: Enter ingredients you have and find matching recipes
- 📱 **Recipe Details**: Complete cooking instructions, ingredients, prep time, and nutrition info
- ❤️ **Save Favorites**: Bookmark recipes for quick access later
- 📊 **Nutrition Tracker**: Calculate total calories and nutrition across saved recipes
- 💾 **Local Storage**: Your saved recipes persist between app sessions
- 🌐 **Cross-Platform**: Works on web, mobile, and desktop

### Recipe Collection (10+ Recipes)
- **🥘 Main Dishes**: Asian Chicken Stir Fry, Creamy Mushroom Pasta, Loaded Beef Tacos, Spaghetti Carbonara, Herb-Crusted Salmon, Chicken Tikka Masala
- **🥗 Soups & Salads**: Hearty Minestrone Soup, Greek Quinoa Salad
- **🥞 Breakfast & Desserts**: Buttermilk Pancakes, Chocolate Chip Cookies

## 🚀 Quick Start

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.8.1)
- [Dart SDK](https://dart.dev/get-dart) (>=3.8.1)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd recipe_finder
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Web (Recommended)
   flutter run -d web-server --web-port 8080
   
   # Chrome
   flutter run -d chrome
   
   # Android
   flutter run -d android
   
   # Desktop (Linux/Windows/macOS)
   flutter run -d linux
   ```

4. **Access the app**
   - Web: Open [http://localhost:8080](http://localhost:8080) in your browser

## 📱 How to Use

### Searching for Recipes
1. **Add Ingredients**: Type ingredients you have (e.g., "chicken", "pasta", "tomato")
2. **Find Recipes**: Click "Find Recipes" to see matching options
3. **Browse All**: Click "Show All Demo Recipes" to see the complete collection

### Managing Recipes
1. **View Details**: Tap any recipe card to see full instructions and ingredients
2. **Save Favorites**: Click the heart icon to bookmark recipes
3. **View Saved**: Switch to the "Saved" tab to see your collection
4. **Nutrition Summary**: View total calories and nutrition stats for saved recipes

### Sample Ingredient Searches
- `chicken` → Asian Chicken Stir Fry, Chicken Tikka Masala
- `pasta` → Creamy Mushroom Pasta, Spaghetti Carbonara
- `beef` → Loaded Beef Tacos
- `salmon` → Herb-Crusted Salmon
- `quinoa` → Greek Quinoa Salad

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── recipe.dart          # Recipe data model
├── services/
│   ├── recipe_service.dart  # Recipe API & mock data
│   └── storage_service.dart # Local storage handling
├── providers/
│   └── recipe_provider.dart # State management
├── screens/
│   ├── home_screen.dart     # Main search interface
│   ├── recipe_detail_screen.dart # Recipe details
│   └── saved_recipes_screen.dart # Saved recipes
└── widgets/
    └── recipe_card.dart     # Recipe display component
```

## 🛠️ Dependencies

```yaml
dependencies:
  flutter: sdk
  http: ^1.1.0              # API requests
  shared_preferences: ^2.2.2 # Local storage
  json_annotation: ^4.8.1    # JSON serialization
  provider: ^6.1.1           # State management
  cupertino_icons: ^1.0.8    # iOS-style icons
```

## 🔧 Development

### Build for Production

**Web:**
```bash
flutter build web
# Output: build/web/
```

**Android APK:**
```bash
flutter build apk
# Output: build/app/outputs/flutter-apk/
```

**Desktop:**
```bash
flutter build linux    # Linux
flutter build windows  # Windows
flutter build macos    # macOS
```

### Using Real Recipe API

To connect to a real recipe API (like [Spoonacular](https://spoonacular.com/food-api)):

1. Get an API key from the provider
2. Replace `DEMO_API_KEY` in `lib/services/recipe_service.dart`
3. Uncomment the API request code in the service file
4. Comment out the mock data section

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines
- Follow [Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
- Add tests for new features
- Update documentation for API changes
- Ensure cross-platform compatibility

## 📋 Features Roadmap

- [ ] User authentication
- [ ] Recipe rating system
- [ ] Shopping list generation
- [ ] Meal planning calendar
- [ ] Recipe sharing
- [ ] Dietary restriction filters
- [ ] Voice search
- [ ] Recipe photos

## 🐛 Known Issues

- Images are currently placeholder URLs
- API integration uses mock data
- Limited recipe filtering options

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Recipe inspiration from various cooking websites
- Icons provided by Flutter's material design library

## 📞 Support

If you have any questions or run into issues:

1. Check the [Flutter documentation](https://docs.flutter.dev/)
2. Search existing [GitHub issues](https://github.com/flutter/flutter/issues)
3. Create a new issue with detailed information

---

**Happy Cooking! 👨‍🍳👩‍🍳**
# recipe-finder
