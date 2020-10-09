import 'package:beech_sign_in/backend/admin.dart';
import 'package:beech_sign_in/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import 'backend/bloc/authservices.dart';
import 'backend/authrepo.dart';
import 'backend/userrepo.dart';
import 'backend/models.dart';


//https://bloclibrary.dev/#/flutterlogintutorial

void main() {
  runApp(MyApp(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository
}) : assert(authenticationRepository != null),
    assert(userRepository != null),
    super(key :key );

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    //Provides authentication repository to the entire app
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
            authenticationRepository: authenticationRepository,
            userRepository: userRepository),
        child: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                    Home.route(), (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil(
                    Authenticate.route(), (route) => false);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}

class Home extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => Home());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
    );
  }
}

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

//TODO Set user and authenticated upon signIn and SignUp
