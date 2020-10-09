import 'dart:async';

import 'package:uuid/uuid.dart';

import 'package:beech_sign_in/backend/models.dart';

//Repositories are what is monitored by streams
//1 create repo 2. create tream to monitior repo

class UserRepository{
  User _user;

  //This is where you would get user from the backedn
  Future<User> getUser() async{
    if(_user != null) return _user;
    return Future.delayed(const Duration(milliseconds: 300),
        ()=> _user = User(),
    );
  }
}