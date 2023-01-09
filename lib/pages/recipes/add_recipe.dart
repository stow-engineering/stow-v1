// Flutter imports:
// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors_in_immutables

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/recipes_bloc.dart';
import 'package:stow/bloc/recipes_events.dart';
import '../../models/recipe.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final uuid = const Uuid();
  TextEditingController nameController = TextEditingController();
  TextEditingController prepController = TextEditingController();
  TextEditingController cookController = TextEditingController();

  static List<String> instructionsList = [""];
  static List<String> ingredientsList = [""];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    prepController.dispose();
    cookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name textfield
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Name of Recipe',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Prep Time',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: TextFormField(
                    controller: prepController,
                    decoration:
                        const InputDecoration(hintText: 'Enter prep time'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Cook Time',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: TextFormField(
                    controller: cookController,
                    decoration:
                        const InputDecoration(hintText: 'Enter cook time'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Instructions',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ..._getInstructions(),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ..._getIngredients(),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final recipe =
                          //Recipe(name: nameController.text, instructions: instructionsController.text, uid: uuid.v4());
                          Recipe(
                              recipeId: uuid.v4(),
                              name: nameController.text,
                              instructions: instructionsList,
                              userId: authBloc.state.user!.uid,
                              ingredients: ingredientsList,
                              cookTimeMin: int.parse(cookController.text),
                              prepTimeMin: int.parse(prepController.text));
                      context.read<RecipesBloc>().add(AddRecipe(recipe));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// get instructions text-fields
  List<Widget> _getInstructions() {
    List<Widget> instructionsTextFields = [];
    for (int i = 0; i < instructionsList.length; i++) {
      instructionsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: InstructionsTextFields(i)),
            const SizedBox(
              width: 16,
            ),
            // we need add button at last instructions row
            _addRemoveButtonInstructions(i == instructionsList.length - 1, i),
          ],
        ),
      ));
    }
    return instructionsTextFields;
  }

  /// add / remove button instructions
  Widget _addRemoveButtonInstructions(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          instructionsList.insert(instructionsList.length, "");
        } else {
          instructionsList.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  // get firends text-fields
  List<Widget> _getIngredients() {
    List<Widget> ingredientsTextFields = [];
    for (int i = 0; i < ingredientsList.length; i++) {
      ingredientsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: IngredientsTextFields(i)),
            const SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButtonIngredients(i == ingredientsList.length - 1, i),
          ],
        ),
      ));
    }
    return ingredientsTextFields;
  }

  // add / remove button
  Widget _addRemoveButtonIngredients(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          ingredientsList.insert(ingredientsList.length, "");
        } else
          ingredientsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class InstructionsTextFields extends StatefulWidget {
  final int index;
  const InstructionsTextFields(this.index, {super.key});
  @override
  _InstructionsTextFieldsState createState() => _InstructionsTextFieldsState();
}

class _InstructionsTextFieldsState extends State<InstructionsTextFields> {
  TextEditingController instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      instructionsController.text =
          _AddRecipePageState.instructionsList[widget.index];
    });

    return TextFormField(
      controller: instructionsController,
      onChanged: (v) => _AddRecipePageState.instructionsList[widget.index] = v,
      decoration:
          const InputDecoration(hintText: 'Enter the step\'s instructions'),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}

class IngredientsTextFields extends StatefulWidget {
  final int index;
  IngredientsTextFields(this.index, {super.key});
  @override
  _IngredientsTextFieldsState createState() => _IngredientsTextFieldsState();
}

class _IngredientsTextFieldsState extends State<IngredientsTextFields> {
  TextEditingController ingredinetsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ingredinetsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ingredinetsController.text =
          _AddRecipePageState.ingredientsList[widget.index];
    });

    return TextFormField(
      controller: ingredinetsController,
      onChanged: (v) => _AddRecipePageState.ingredientsList[widget.index] = v,
      decoration: const InputDecoration(hintText: 'Enter an ingredient'),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
