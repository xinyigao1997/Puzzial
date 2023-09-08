/// A class representing a player in the game.
class Player {
  /// Constructs a [Player] object with the required fields.
  Player(
      {required this.playerId,
      required this.emailAddress,
      required this.userName,
      required this.profilePhoto});

// The unique ID of the player.
  final String playerId;

  /// The email address associated with the player's account.
  final String? emailAddress;

  /// The display name of the player.
  final String? userName;

  /// The URL of the player's profile photo.
  final String? profilePhoto;

  /// Returns a [Map] containing the player's information.
  Map<String, dynamic> getPlayerInfo() {
    return {
      'playerId': playerId,
      'emailAddress': emailAddress,
      'userName': userName,
      'profilePhoto': profilePhoto
    };
  }
}
