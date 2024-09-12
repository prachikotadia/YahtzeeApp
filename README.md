
# Yahtzee

## Overview

In this machine problem, your task is to complete the implementation of a single-player [Yahtzee](https://en.wikipedia.org/wiki/Yahtzee) game. Yahtzee is a dice game in which the player rolls five dice up to three times in an attempt to achieve various scoring combinations. The player's score is determined by the sum of the values of the dice when a scoring combination is achieved.

If you're not familiar with Yahtzee, here are some resources:

- [The Wikipedia writeup](https://en.wikipedia.org/wiki/Yahtzee)
- An [online version of the game](https://cardgames.io/yahtzee/)

Before moving on, take a moment to familiarize yourself with the basic setup and rules of the game. You'll need to understand them to complete the assignment.

The primary objective of this MP is to provide you with an opportunity to employ various stateful widgets and state-management techniques to implement a non-trivial, single-page application.


## Specifications

The version of Yahtzee you will implement is a slightly simplified, single-player version of the game. The player will be able to roll the dice up to three times per turn, choosing a scoring category to end each turn. The game ends when the player has entered a score in each of the 13 categories on the scorecard. Our version will not include the "Yahtzee bonus" rule, which awards additional points for multiple Yahtzees.

## Implementation details / requirements

### Behavior

As demonstrated in the video above, the app should clearly display the following information at all times:

- the most recently rolled dice faces in the current turn (if any)
- which dice are currently "held" (if any)
- the next roll number (1-3) of the current turn
- the score corresponding to each used category on the scorecard
- the remaining, unused categories on the scorecard
- the current total score

The app should provide the following functionality:

- a mechanism for rolling the dice (e.g., a button), which should be disabled when the player has already rolled three times in the current turn
- a mechanism (we use a `GestureDetector` in the demo app) for toggling the "held" state of each die
- a mechanism for selecting a scoring category to end the current turn
- when the game ends, the app should display the final score until the user dismisses it (we suggest using an [`AlertDialog`](https://api.flutter.dev/flutter/material/AlertDialog-class.html) for this purpose) --- after dismissal, the game should reset to the initial state and be ready to be played again


### Screen layout and dimensions

You should lay out your app so that it fits within a 720p (1280x720 pixels) resolution window without overflow or need for scrolling. Note that this means it may not display correctly in an Android or iOS emulator, which is fine for this machine problem.


### Project setup

This repository includes a basic Flutter project structure, which you should use as a starting point for your implementation. Do not make changes to the `pubspec.yaml` file (which specifies the project dependencies) without first consulting with us.

You will need to modify `lib/main.dart`, and you can add UI-related source files (e.g., custom `Widget`s) to the `lib/views` directory, data model source files to the `lib/models` directory, and image files to the `assets/images` directory. All your added source files should be written in Dart.


### External packages

We have included both the [`provider`](https://pub.dev/packages/provider) and [`collection`](https://pub.dev/packages/collection) packages in the `pubspec.yaml` file. `provider` is a state management package that you may use to manage the stateful data, and `collection` provides some helpful data structure related operations.


### `Dice`, `ScoreCategory`, and `Scorecard` classes

Because the focus of this machine problem is to practice using stateful widgets, we've provided you with classes that represent the dice, score categories, and scorecard. These classes are defined in the `lib/models/dice.dart` and `lib/models/scorecard.dart` files.

The `Dice` class represents some fixed number of 6-sided dice, each of which may be "held" or "unheld", which affects whether it is randomly updated when `roll` is called. Here's an example of how you might use the `Dice` class:

```dart
final dice = Dice(5); // all 5 dice are initially unheld and null

dice.roll();
print(dice.values);

dice.toggleHold(0); // hold the first die
dice.toggleHold(3); // hold the fourth die

dice.roll();
print(dice.values);

dice.clear(); // clear and unhold all dice values
dice.roll();
print(dice.values);

print(dice[0]);
print(dice.isHeld(0));
```

Sample output for the code above follows:

```
[5, 6, 5, 4, 3]
[5, 4, 6, 4, 1]
[2, 3, 1, 2, 3]

2

false
```

`ScoreCategory` is an enumeration of the 13 possible scoring categories in Yahtzee.

`Scorecard` represents the scorecard used in Yahtzee. It maps `ScoreCategory` values to nullable `int` values to represent the score for a given category (or `null` if the category has not yet been used).

Here's an example of how you might use the three provided classes together:

```dart
final scoreCard = ScoreCard();

scoreCard.registerScore(ScoreCategory.threeOfAKind, 
                        <int>[4, 4, 2, 4, 5]);
print(scoreCard[ScoreCategory.threeOfAKind]);

final dice = Dice(5);
dice.roll();
print(dice.values);

scoreCard.registerScore(ScoreCategory.chance, dice.values);
print(scoreCard[ScoreCategory.chance]);

for (final cat in ScoreCategory.values) {
  print('${cat.name}: ${scoreCard[cat]}');
}

print('All categories used? ${scoreCard.completed}');
print('Total score = ${scoreCard.total}');

scoreCard.clear();
print(scoreCard[ScoreCategory.chance]);
```

Sample output for the code above follows:

```
19

[3, 5, 2, 6, 6]

22

Ones: null
Twos: null
Threes: null
Fours: null
Fives: null
Sixes: null
Three of a Kind: 19
Four of a Kind: null
Full House: null
Small Straight: null
Large Straight: null
Yahtzee: null
Chance: 22

All categories used? false
Total score = 41

null
```

While you are free to use the provided classes as-is, you may either ignore them altogether or modify them to suit your implementation. For instance, you may find it useful to make `Dice` and/or `Scorecard` extend  `ChangeNotifier`. 

If you choose not to use them, you will need to implement your own model classes so as to separate your game data and logic from the UI. Feel free to remove the files from the repository if they are unneeded.


### Code structure

- the main Yahtzee game container
- the dice display
- the scorecard display
