class Recipe {
  final String id;
  final String title;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;
  final int readyInMinutes;
  final int servings;
  final double calories;
  final String summary;
  bool isSaved;

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
    this.isSaved = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      ingredients: _parseIngredients(json['extendedIngredients'] ?? []),
      instructions: _parseInstructions(json['analyzedInstructions'] ?? []),
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 1,
      calories: _calculateCalories(json['nutrition']),
      summary: json['summary'] ?? '',
    );
  }

  static List<String> _parseIngredients(List<dynamic> ingredients) {
    return ingredients.map((ingredient) => ingredient['original'].toString()).toList();
  }

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

  static double _calculateCalories(Map<String, dynamic>? nutrition) {
    if (nutrition == null || nutrition['nutrients'] == null) return 0.0;
    
    for (var nutrient in nutrition['nutrients']) {
      if (nutrient['name'] == 'Calories') {
        return (nutrient['amount'] as num).toDouble();
      }
    }
    return 0.0;
  }

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

  factory Recipe.fromSavedJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      calories: json['calories'],
      summary: json['summary'],
      isSaved: json['isSaved'] ?? false,
    );
  }
}
