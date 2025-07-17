# 📁 Lib Folder Structure - Recipe Finder App

This document explains the purpose and usage of each file and folder in the `lib` directory.

## 📂 **Folder Structure Overview**

```
lib/
├── main.dart                 # 🚀 App entry point and navigation setup
├── models/                   # 📊 Data structures and models
│   └── recipe.dart          # Recipe data model with JSON serialization
├── providers/                # 🔄 State management (Provider pattern)
│   └── recipe_provider.dart # Global state for recipes and favorites
├── screens/                  # 📱 UI screens/pages of the app
│   ├── home_screen.dart     # Main search and recipe listing screen
│   ├── recipe_detail_screen.dart # Detailed recipe view screen
│   └── saved_recipes_screen.dart # Saved/favorite recipes screen
├── services/                 # 🛠️ Business logic and external services
│   ├── recipe_service.dart  # Recipe API calls and data fetching
│   └── storage_service.dart # Local storage operations
└── widgets/                  # 🧩 Reusable UI components
    └── recipe_card.dart     # Recipe card widget for lists
```

## 📋 **Detailed File Purposes**

### **🚀 main.dart**
- **Purpose**: App entry point and root configuration
- **Contains**: App theme, navigation setup, provider initialization
- **Usage**: First file that runs when app starts

### **📊 models/ Directory**
- **Purpose**: Data structures that represent app entities
- **Why Created**: Organize data models separately from UI code
- **Benefits**: Type safety, JSON serialization, code reusability

### **🔄 providers/ Directory**
- **Purpose**: State management using Provider pattern
- **Why Created**: Share data between screens without passing props
- **Benefits**: Global state access, reactive UI updates

### **📱 screens/ Directory**
- **Purpose**: Full-screen UI pages that users navigate between
- **Why Created**: Separate each major app screen for better organization
- **Benefits**: Modular code, easy navigation management

### **🛠️ services/ Directory**
- **Purpose**: Business logic and external service integrations
- **Why Created**: Separate data operations from UI components
- **Benefits**: Reusable logic, easier testing, clean architecture

### **🧩 widgets/ Directory**
- **Purpose**: Reusable UI components used across multiple screens
- **Why Created**: Avoid code duplication, create consistent UI elements
- **Benefits**: Maintainable code, consistent design, reusability

## 🔗 **How Files Work Together**

1. **main.dart** → Sets up the app and provides global state
2. **models/recipe.dart** → Defines recipe data structure
3. **services/** → Fetch and store recipe data
4. **providers/** → Manage app state and notify UI of changes
5. **screens/** → Display UI and handle user interactions
6. **widgets/** → Provide reusable UI components

## 🚀 **Data Flow Example**

```
User searches for recipe → home_screen.dart → recipe_provider.dart → recipe_service.dart → Returns recipes → Updates UI
```

This architecture follows Flutter best practices for scalable, maintainable applications.
