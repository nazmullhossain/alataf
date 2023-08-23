// import 'package:alataf/models/Products.dart';
// import 'package:flutter/material.dart';
//
// import 'package:provider/provider.dart';
//
// import '../bloc/SearchBloc.dart';
// import '../models/search_new_models.dart';
// import '../provider/imge_provider.dart';
//
//
//
// class RecipeWidget extends StatefulWidget {
//   final ProductItem recipeModel;
//
//   const RecipeWidget(this.recipeModel, {super.key});
//
//   @override
//   State<RecipeWidget> createState() => _RecipeWidgetState();
// }
//
// class _RecipeWidgetState extends State<RecipeWidget> {
//   SearchBloc searchBloc=SearchBloc();
//   @override
//   Widget build(BuildContext context) {
//     return  searchBloc==null?Text("nota have data"):  InkWell(
//       onTap: (() {
//
//       }
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//
//         margin: const EdgeInsets.all(5),
//         padding: const EdgeInsets.all(5),
//         child: ListTile(
//
//
//
//           title: Text("${widget.recipeModel.categoryName}"),
//
//
//         ),
//       ),
//     );
//   }
// }
