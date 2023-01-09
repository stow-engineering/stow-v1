class InstructionsResponse {
  List<Instructions> results = <Instructions>[];

  InstructionsResponse(this.results);

  InstructionsResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Instructions>[];
      json['results'].forEach((v) {
        results.add(Instructions.fromJson(v));
      });
    }
  }
}

class Instructions {
  String title = "";
  List<Step> steps = <Step>[];

  Instructions({required this.title, required this.steps});

  Instructions.fromJson(Map<String, dynamic> json) {
    title = json['title'];

    //Gets ingredients from response from used ingredients
    var tempSteps = json['usedIngredients'].toList();

    for (var item in tempSteps) {
      steps.add(Step(item['description'], item['number']));
    }

    // //Gets ingredients from response from missing ingredients
    tempSteps = json['missedIngredients'].toList();

    for (var item in tempSteps) {
      steps.add(Step(item['description'], item['number']));
    }
  }
}

class Step {
  String description = "";
  int number = 0;

  Step(this.description, this.number);
}
