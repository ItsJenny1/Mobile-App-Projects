import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => memoryCardGame(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Memory Game'),
          ),
          body: const memoryGame(),
        ),
      ),
    );
  }
}

class memoryGame extends StatelessWidget {
  const memoryGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<memoryCardGame>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: model.cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemBuilder: (context, index) {
          return CardWidget(index: index);
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final int index;

  const CardWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<memoryCardGame>(context);
    final card = model.cards[index];

    return GestureDetector(
      onTap: () {
        if (model.chosenCards.length < 2) {
          model.flipCard(index);
        }
        if (model.chosenCards.length == 2) {
          model.disableTap();
          model.checkMatch();
          if (model.allCardsMatched()) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Victory!'),
                content: Text(
                    'Congratulations, you have won the game! Press ok to reload'),
                actions: [
                  TextButton(
                    onPressed: () {
                      model.resetGame();
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: card.isFaceUp
            ? flipAnimation(
                key: ValueKey<bool>(true),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  color: Color.fromARGB(255, 245, 175, 191),
                  child: Center(
                    child: Icon(
                      card.icon,
                      size: 40,
                      color: Color.fromRGBO(240, 129, 69, 1),
                    ),
                  ),
                ),
              )
            : flipAnimation(
                key: ValueKey<bool>(false),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  color: Color.fromARGB(255, 22, 103, 133),
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      size: 40,
                      color: Color.fromRGBO(240, 129, 69, 1),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}


class memoryCardGame extends ChangeNotifier {
  List<CardModel> cards = [];
  List<int> chosenCards = [];
  int matchedPairs = 0;
  bool isTapEnabled = true;

  memoryCardGame() {
    for (int i = 0; i < 8; i++) {
      cards.add(CardModel(icon: _getIconData(i)));
      cards.add(CardModel(icon: _getIconData(i)));
    }
    cards.shuffle();
  }

  void flipCard(int index) {
    cards[index].isFaceUp = !cards[index].isFaceUp;
    if (cards[index].isFaceUp) {
      chosenCards.add(index);
    } else {
      chosenCards.remove(index);
    }
    notifyListeners();
  }

  void checkMatch() {
    if (cards[chosenCards[0]].icon == cards[chosenCards[1]].icon) {
      chosenCards.clear();
      matchedPairs++;
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        cards[chosenCards[0]].isFaceUp = false;
        cards[chosenCards[1]].isFaceUp = false;
        chosenCards.clear();
        notifyListeners();
      });
    }
    notifyListeners();
  }

  bool allCardsMatched() {
    return matchedPairs == cards.length ~/ 2;
  }

  void disableTap() {
    isTapEnabled = false;
    notifyListeners();
  }

  void enableTap() {
    isTapEnabled = true;
    notifyListeners();
  }

  void resetGame() {
    cards.forEach((card) {
      card.isFaceUp = false;
    });
    cards.shuffle();
    chosenCards.clear();
    matchedPairs = 0;
    enableTap();
    notifyListeners();
  }

  static IconData _getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.adb_rounded;
      case 1:
        return Icons.star;
      case 2:
        return Icons.add_reaction;
      case 3:
        return Icons.star_border;
      case 4:
        return Icons.access_alarm;
      case 5:
        return Icons.all_inclusive_rounded;
      case 6:
        return Icons.anchor_rounded;
      case 7:
        return Icons.account_balance;
      default:
        return Icons.error;
    }
  }
}

class CardModel {
  IconData icon;
  bool isFaceUp;

  CardModel({required this.icon, this.isFaceUp = false});
}

class flipAnimation extends StatelessWidget {
  final Widget child;

  const flipAnimation({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? child) {
        final double angle =
            value * 3.14159; 
        final Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) 
          ..rotateY(angle); 
        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: child,
        );
      },
      child: child,
    );
  }
}

