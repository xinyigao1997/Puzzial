import 'package:flutter/material.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/avatar_widget.dart';

/// A Flutter widget that displays a column of [Avatar] widgets.
///
/// This widget takes the players from the [GameState] instance
/// and creates a list of [Avatar] widgets to display each player's profile photo
/// in a vertical column with padding between each avatar.
///
/// {@tool snippet}
///
/// Usage example:
///
/// ```dart
/// AvatarColumn();
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Avatar], the widget used to display the profile photo.
///  * [GameState], the class holding game state data.
class AvatarColumn extends StatefulWidget {
  /// Creates an [AvatarColumn] widget.
  ///
  /// The [key] parameter is optional and can be used for identifying
  /// this widget in the widget tree.
  const AvatarColumn({
    Key? key,
  }) : super(key: key);

  @override
  AvatarColumnState createState() => AvatarColumnState();
}

class AvatarColumnState extends State<AvatarColumn> {
  List<Avatar> avatars = [];

  @override
  void initState() {
    super.initState();
    _createAvatars();
  }

  /// Creates a list of [Avatar] widgets based on the players from the [GameState] instance.
  ///
  /// This method generates a list of [Avatar] widgets with the corresponding
  /// profile photos of the players, size, and border radius.
  void _createAvatars() {
    avatars = List.generate(
      GameState.instance.players.length,
      (index) => Avatar(
        imageUrl: GameState.instance.players[index].profilePhoto ?? '',
        size: GameState.instance.screenWidth * 0.06,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: avatars.map((avatar) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: avatar,
        );
      }).toList(),
    );
  }
}
