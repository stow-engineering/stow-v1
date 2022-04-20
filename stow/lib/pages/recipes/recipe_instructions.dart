import 'package:flutter/material.dart';
import 'package:stow/models/instructions_model.dart';
import 'package:stow/models/recipe_model.dart';
import 'package:stow/utils/http_service.dart';

class RecipeInstructions extends StatefulWidget{
  final Recipe recipe;
  const RecipeInstructions({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  _RecipeInstructionsState createState(){
    return _RecipeInstructionsState();
  }
}

class _RecipeInstructionsState extends State<RecipeInstructions>{
    final HttpService httpService = HttpService();
  
   @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   getContainerStream();
    // });
  }

  @override
  Widget build(BuildContext context) {
    //DatabaseService service = DatabaseService(widget.user.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),  
      body: FutureBuilder(
        future: httpService.getRecipeInstructions(widget.recipe.id),
        builder: (BuildContext context, AsyncSnapshot<List<Instructions>> snapshot) {
          if(snapshot.hasData){
            List<Instructions> instructions = snapshot.data ?? <Instructions>[];
            int length = 0;
            for(var item in instructions){
              length = item.steps.length + length;
            }
            
            return SafeArea(
              child: ListView.builder(
                itemCount: instructions.length,
                itemBuilder: (BuildContext context, int index){
                  return ListView.builder(
                    itemCount: instructions.elementAt(index).steps.length,
                    itemBuilder: (BuildContext innerContext, int innerIndex) {
                      return Text(instructions.elementAt(index).steps.elementAt(innerIndex).toString());
                    }
                  );
                },
              )
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
