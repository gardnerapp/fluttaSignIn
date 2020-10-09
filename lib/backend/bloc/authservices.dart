
import 'dart:async';
import 'package:beech_sign_in/backend/authrepo.dart';
import 'package:beech_sign_in/backend/userrepo.dart';
import 'package:equatable/equatable.dart';
import 'package:beech_sign_in/backend/models.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationEvent extends Equatable{
  const AuthenticationEvent();

  @override
  List<Object> get props => [];

}

class AuthenticationStatusChanged extends AuthenticationEvent{
  const AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];

}

class AuthenticationLogoutRequest extends AuthenticationEvent{}


class AuthenticationState extends Equatable{
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
});
// Prevents sub classsing

  //Default status is set to unknown

  //this sets the status based on the incoming state
  const AuthenticationState.unknown() : this._();

  //if auth state is authenticated this private member has a status of authenticated
  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated);

  const AuthenticationState.unauthenticated()
    : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final User user;


  //geters and setters provide access to an objects properties
//so this sets the obj proops into a list making them easier to reference later on
  @override
  List<Object> get props => [status, user];
}

//Used to manage auth state, which determines UI
//something to monitor, something to hold, something to change

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
    @required UserRepository userRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
  //Setting the private members seems redundant, should I eliminate this
        _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,

  //Super is used to refer to parent class
  //In this case the authenticationstate is set to unknown
  // and listens to the authentication repository


  //Defines the intitial authentication state as unknown
        super(const AuthenticationState.unknown()) {

    //subscribe to the authentication status of the repository
    // create new status upon status changge to a new auth status

    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AuthenticationStatusChanged){
      yield await _mapAuthenticationStatusChangedToState(event);
    }else if(event is AuthenticationLogoutRequest){
    _authenticationRepository.logOut();
    }
  }

  //must overide the status subscription and auth repo upon close

  @override
  Future<void> close(){
    _authenticationStatusSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }


  //maps the event change to that of an authentication state
  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
      AuthenticationStatusChanged event
      ) async{
    //return state based on status
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        //if authenticated get and set user, set the user to the attrib of user in authenticated
        final user = await _tryGetUser();
        //if no user is gotten set the authentication state back to unauthenticated
        return user != null ? AuthenticationState.authenticated(user) : const AuthenticationState.unauthenticated();
      default:
        //fallback of unknown
        return const AuthenticationState.unknown();
    }
  }

  Future<User> _tryGetUser() async {
    try{
      final user = await _userRepository.getUser();
      return user;
    } on Exception {
      return null;
    }
  }



}




