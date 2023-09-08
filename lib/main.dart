import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:puzzial/models/player.dart';
import 'package:puzzial/multiple_firebase_options.dart';
import 'package:puzzial/screens/game_screen.dart';
import 'package:puzzial/screens/home_screen.dart';
import 'package:puzzial/state/game_state.dart';

/// The Google API client ID.
const String clientId =
    '198146297205-b5ebbbo4i6n7idab41184n383mvl7nkv.apps.googleusercontent.com';

/// A global key to access the NavigatorState.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Instances of FirebaseApp for login and game state.
late FirebaseApp loginApp;
// late FirebaseApp gameStateApp;

/// The main function that initializes and runs the app.
///
/// This function ensures the WidgetsFlutterBinding is initialized, sets up
/// two Firebase applications for handling login and game state, configures
/// authentication providers, sets the preferred device orientation, and runs
/// the MyApp widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  loginApp = await Firebase.initializeApp(
    name: 'loginApp',
    options: MultipleFirebaseOptions.loginAppOptions,
  );

  FlutterFireUIAuth.configureProviders([
    const GoogleProviderConfiguration(clientId: clientId),
  ]);
  GameState.factory = DefaultGameStateFactory();
  await GameState.factory.create();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]).then((_) => runApp(ChangeNotifierProvider(
      create: (_) => GameState.instance, child: const MyApp())));
}

/// A StatefulWidget representing the main application.
class MyApp extends StatefulWidget {
  /// Constructs a MyApp widget.
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

/// A state class for the [MyApp] widget that handles application lifecycle events.
class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handles changes in the application lifecycle state.
  ///
  /// This method responds to the [AppLifecycleState.resumed] and
  /// [AppLifecycleState.detached] events by calling [_handleAppResumed] and
  /// [_handleAppDetached], respectively.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed &&
        GameState.instance.loggedIn == true) {
      await _handleAppResumed();
    } else if (state == AppLifecycleState.detached) {
      await _handleAppDetached();
    }
  }

  /// Handles the app resuming from a paused state.
  ///
  /// This method is called when the application resumes and the user is logged in.
  /// It reads the clipboard data and validates the session. If the session is valid,
  /// it navigates to the game page and reloads the session.
  Future<void> _handleAppResumed() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    String? text = clipboardData?.text;
    final GameState state = GameState.instance;

    if (text != null) {
      List<String> inviteLink = text.split("SEP");
      String sessionId = inviteLink[0];
      String downloadUrl = inviteLink[1];

      if (state.sessionId == null &&
          state.loggedIn == true &&
          await state.validateSession(sessionId) == true) {
        ValueNotifier<bool> isReloadingNotifier = ValueNotifier<bool>(true);
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => GamgePage(isCutting: isReloadingNotifier),
          ),
        );
        state.sessionId = sessionId;
        await state.reloadSession(sessionId, downloadUrl);
        isReloadingNotifier.value = false;
      }
    }
  }

  /// Handles the app detaching from the engine.
  ///
  /// This method is called when the application is detached. If the current user is
  /// the session creator, it removes the session from the database.
  Future<void> _handleAppDetached() async {
    final GameState state = GameState.instance;
    if (state.sessionId != null &&
        FirebaseAuth.instance.currentUser != null &&
        state.sessionId == FirebaseAuth.instance.currentUser!.uid) {
      await state.database!.child(state.sessionId!).remove();
    }
  }

  /// Builds the MaterialApp with the given context.
  ///
  /// This method sets the navigator key, theme, and home widget for the MaterialApp.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(),
      ),
      home: const AuthGate(),
    );
  }
}

/// The authentication gate widget.
///
/// This widget is responsible for managing user authentication, displaying the
/// sign in screen when needed, and updating the game state based on the
/// authenticated user.
class AuthGate extends StatefulWidget {
  /// Constructs an AuthGate widget.
  const AuthGate({Key? key}) : super(key: key);

  @override
  AuthGateState createState() => AuthGateState();
}

/// A state class for the [AuthGate] widget.
class AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
  }

  /// Handles dependencies changes and updates the game state.
  ///
  /// This method sets the game state properties based on the current context.
  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final GameState state = GameState.instance;
    state.screenWidth = MediaQuery.of(context).size.width;
    state.screenHeight = MediaQuery.of(context).size.height;
    state.puzzleWidth = state.screenWidth * 0.7;
  }

  /// Builds the authentication gate widget based on the authentication state.
  ///
  /// This method uses a [StreamBuilder] to reactively update the widget based on
  /// the authentication state of the user. If the user is not authenticated, it
  /// displays the sign in screen. If the user is authenticated, it updates the
  /// game state and displays the home screen.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Semantics(
            label:
                "Please sign in with your email and password, phone number, or Google sign in.",
            child: const SignInScreen(providerConfigs: [
              GoogleProviderConfiguration(
                clientId: clientId,
              ),
            ]),
          );
        }

        if (FirebaseAuth.instance.currentUser != null) {
          _updateGameState();
        }

        return const HomeScreen();
      },
    );
  }

  /// Updates the game state based on the authenticated user.
  ///
  /// This method sets the `loggedIn` property of the game state, adds the authenticated
  /// user to the list of players, and adds their ID to the list of session user IDs.
  void _updateGameState() {
    String id = FirebaseAuth.instance.currentUser!.uid;
    GameState.instance.loggedIn = true;

    if (!GameState.instance.sessionUserIds.contains(id)) {
      final curUser = FirebaseAuth.instance.currentUser!;
      GameState.instance.players.add(Player(
        playerId: id,
        emailAddress: curUser.email,
        userName: curUser.displayName,
        profilePhoto: curUser.photoURL,
      ));
      GameState.instance.sessionUserIds.add(id);
    }
  }
}
