import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:puzzial/state/game_state.dart';

/// A Flutter widget that displays the game mode controller options for the game.
///
/// This widget is a stateful widget that presents a user interface allowing
/// users to select the difficulty level and game mode (number of players)
/// for the game.
///
/// {@tool snippet}
///
/// Usage example:
///
/// ```dart
/// GameModeControllerWidget();
/// ```
/// {@end-tool}
class GameModeControllerWidget extends StatefulWidget {
  /// Creates a [GameModeControllerWidget].
  ///
  /// The [key] parameter is optional and can be used for identifying
  /// this widget in the widget tree.
  const GameModeControllerWidget({super.key});

  @override
  State<GameModeControllerWidget> createState() =>
      _GameModeControllerWidgetState();
}

/// The state class for the [GameModeControllerWidget].
///
/// This class is responsible for maintaining and updating the user's
/// choice of difficulty and number of players. It also updates the
/// [GameState] instance to reflect the user's selections.
class _GameModeControllerWidgetState extends State<GameModeControllerWidget> {
  /// The currently selected difficulty level.
  int tagDifficulty = GameState.instance.currentLevel;

  /// A list of available difficulty levels.
  List<String> optionsDifficulty = [
    'Easy',
    'Medium',
    'Hard',
    'Hell',
  ];

  /// The currently selected number of players (0 for single player, 1 for two players).
  int tagNumOfPlayers = 0;

  /// A list of available number of players options.
  List<String> optionsNumOfPlayers = [
    'One Player',
    'Two Players',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.32,
                              child: Content(
                                title: 'Difficulty Level',
                                child: ChipsChoice<int>.single(
                                  value: tagDifficulty,
                                  onChanged: (val) {
                                    setState(() => tagDifficulty = val);
                                    GameState.instance.currentLevel = val;
                                    var n = (val + 1) * 2;
                                    GameState.instance.rows = n;
                                    GameState.instance.cols = n;
                                  },
                                  choiceItems: C2Choice.listFrom<int, String>(
                                    source: optionsDifficulty,
                                    value: (i, v) => i,
                                    label: (i, v) => v,
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  choiceBuilder: (item, i) {
                                    return CustomChip(
                                      label: item.label,
                                      width: double.infinity,
                                      height: 40,
                                      color: Colors.purple,
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      selected: item.selected,
                                      onSelect: item.select!,
                                    );
                                  },
                                  direction: Axis.vertical,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.32,
                              child: Center(
                                child: Content(
                                  title: 'Game Mode',
                                  child: ChipsChoice<int>.single(
                                    value: tagNumOfPlayers,
                                    onChanged: (val) => setState(() {
                                      tagNumOfPlayers = val;
                                      GameState.instance.isSinglePlayer =
                                          (val == 0);
                                    }),
                                    choiceItems: C2Choice.listFrom<int, String>(
                                      source: optionsNumOfPlayers,
                                      value: (i, v) => i,
                                      label: (i, v) => v,
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 20),
                                    choiceBuilder: (item, i) {
                                      return CustomChip(
                                        label: item.label,
                                        width: double.infinity,
                                        height: 40,
                                        color: Colors.purple,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        selected: item.selected,
                                        onSelect: item.select!,
                                      );
                                    },
                                    direction: Axis.vertical,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton.icon(
                      label: const Text(
                        'Home Page',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.black.withOpacity(0.8), // Background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: Colors.deepPurple.shade700,
                            width: 2,
                          ),
                        ),
                        elevation: 5, // Shadow elevation
                        shadowColor: Colors.deepPurple.shade300, // Shadow color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final String label;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool selected;
  final Function(bool selected) onSelect;

  const CustomChip({
    Key? key,
    required this.label,
    this.color,
    this.width,
    this.height,
    this.margin,
    this.selected = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      duration: const Duration(milliseconds: 300),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: selected
            ? (color ?? Colors.green)
            : theme.unselectedWidgetColor.withOpacity(.12),
        borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
        border: Border.all(
          color: selected
              ? (color ?? Colors.green)
              : theme.colorScheme.onSurface.withOpacity(.38),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
        onTap: () => onSelect(!selected),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 9,
              right: 9,
              // bottom: 7,
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        selected ? Colors.white : theme.colorScheme.onSurface,
                    fontSize: 14,
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

class Content extends StatefulWidget {
  final String title;
  final Widget child;

  const Content({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            // color: Colors.blueGrey[50],
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  // color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Flexible(fit: FlexFit.loose, child: widget.child),
        ],
      ),
    );
  }
}
