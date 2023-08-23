import 'dart:io';

class RecipeModel {
  int? id;
  late String name;


  RecipeModel({
    this.id,
    required this.name,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,

    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
        id: map['id'],
        name: map['name'],


    );
  }
}
