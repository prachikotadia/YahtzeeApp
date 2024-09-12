// ignore_for_file: avoid_unnecessary_containers, library_private_types_in_public_api, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

class Yahtzee extends StatefulWidget {
  const Yahtzee({super.key});
  @override
  _YahtzeeState createState() => _YahtzeeState();
}

class _YahtzeeState extends State<Yahtzee> {
  Dice dice = Dice(5);
  ScoreCard scoreCard = ScoreCard();
  int diceRollLeft = 3;
  int countOfCategories=13;
  List<bool> selectedCategories = List.generate(
    ScoreCategory.values.length,
    (index) => false,
  );


  void valuesReset() {
    setState(() {
      dice = Dice(5);
      scoreCard = ScoreCard();
      diceRollLeft = 3;
      countOfCategories = 13;
      selectedCategories = List.generate(
        ScoreCategory.values.length,
            (index) => false,
      );
    });
  }


  void DiceRolling() {
    if (diceRollLeft > 0) {
      setState(() {
        dice.roll();
        diceRollLeft--;
      });
    }
  }

  void Dialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Makes dialog modal
      builder: (BuildContext context) {
        // Using AnimatedContainer for subtle entrance animation
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)), // Smoother edges
            title: const Row(
              children: [
                Icon(Icons.star_rate, color: Colors.orangeAccent),
                SizedBox(width: 10),
                Text('Game Over!'),
              ],
            ),
            content: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  const TextSpan(text: 'You scored a '),
                  TextSpan(text: '${scoreCard.total}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const TextSpan(text: ' points.\n\nReady for another round?'),
                ],
              ),
            ),
            actions: <Widget>[
              // Adding a bit of flair to the button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Background color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('PLAY AGAIN', style: TextStyle(color: Colors.white)),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                  valuesReset();
                },
              ),
            ],
          ),
        );
      },
    );
  }

List<ScoreCategory> types = ScoreCategory.values.toList();

 void chooseCategory(ScoreCategory types) {
  if ((diceRollLeft < 3 && diceRollLeft >= 0) && countOfCategories > 0) {
    setState(() {
      scoreCard.registerScore(types, dice.values);
      diceRollLeft = 3;
      dice.clear();
      selectedCategories[types.index] = true;
      countOfCategories--;
    });
    if (countOfCategories == 0) {
      Dialog(context); // This will show the dialog when all categories are selected
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yahtzee Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              children: List.generate(5, (index) => DiceWidget(dice: dice, index: index)), 
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: DiceRolling,
              child: Text('Remaining Rolls: $diceRollLeft'),
            ),

            const SizedBox(height: 15),
            Column(
              children: List.generate(types.length ~/ 2, (index) {
                final leftone = types[index];
                final rightone = types[index + 6];
                return 

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        leftone.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10.0, // Change the font size
                                          color: Color.fromARGB(255, 3, 39, 69), 
                                        ),
                                      ),
                                    ),
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                chooseCategory(leftone);
                              },
                              child: selectedCategories[leftone.index] == true
                                  ? Container(
                                      child: Center(
                                        child: Text(
                                          '${scoreCard.getScore(leftone) ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        chooseCategory(leftone);
                                      },
                                      child: const Text('Pick'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                 Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            rightone.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10.0, // Change the font size
                              color: Color.fromARGB(255, 3, 39, 69), // Change the text color to blue
                            ),
                          ),
                        ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            chooseCategory(rightone);
                          },
                          child: selectedCategories[rightone.index] == true
                              ? Container(
                                  child: Center(
                                    child: Text(
                                      '${scoreCard.getScore(rightone) ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    chooseCategory(rightone);
                                  },
                                  child: const Text('Pick'),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
             );
             }),
            ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 224, 222, 228).withOpacity(0.0),          
                        borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ScoreCategory.chance.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 57, 2, 73),
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            chooseCategory(ScoreCategory.chance);
                          },
                          child:
                              selectedCategories[ScoreCategory.chance.index] == true
                                  ? Container(
                                      child: Center(
                                        child: Text(
                                          '${scoreCard.getScore(ScoreCategory.chance) ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        chooseCategory(ScoreCategory.chance);
                                      },
                                      child: const Text('Pick'),
                                    ),
                        ),
                      )
                ],
              ),
            ),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(255, 95, 66, 108), Color.fromARGB(255, 65, 39, 69)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 100, 78, 110).withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Text(
                              "Current Score: ${scoreCard.total}",
                              key: ValueKey<int>(scoreCard.total), // Ensure the widget rebuilds when score changes
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
          ],
        ),
      ),
    );
  }
}


class DiceWidget extends StatefulWidget {
  final Dice dice;
  final int index;

  const DiceWidget({Key? key, required this.dice, required this.index}) : super(key: key);

  @override
  _DiceWidgetState createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> {
  @override
  Widget build(BuildContext context) {
    final isHeld = widget.dice.isHeld(widget.index);
    final diceValue = widget.dice[widget.index];
    final color = isHeld ? const Color.fromARGB(255, 237, 212, 249) : Color.fromARGB(255, 211, 185, 224);
    final shadow = isHeld ? BoxShadow(color: const Color.fromARGB(255, 66, 70, 73).withOpacity(0.5), blurRadius: 8, spreadRadius: 1) : BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8, spreadRadius: 1);

    return GestureDetector(
      onTap: () {
        widget.dice.toggleHold(widget.index);
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [shadow],
        ),
        child: Center(
          child: Text(
            '${diceValue ?? ''}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHeld ? Color.fromARGB(255, 214, 198, 214) : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

