import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

enum AuthenticationStatus {unknown, authenticated, unauthenticated}

class AuthenticationRepository{
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async*{
    await Future<void>.delayed(const Duration(seconds:1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);

    await Future.delayed(const Duration(milliseconds: 300),
          ()=> _controller.add(AuthenticationStatus.authenticated),
    );
  }

  void logOut(){
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}


