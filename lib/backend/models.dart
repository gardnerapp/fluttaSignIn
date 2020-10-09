import 'package:equatable/equatable.dart';

//Responsible for user domain and the apis interacting  user
//Equitable reduces boiler plate by overiding == and hashcode



class User extends Equatable{
  final String name;
  final String phone;
  final String email;
  final String address;
  final String password;
  final String uid;

  User({this.name, this.phone, this.email, this.address, this.password, this.uid});

  //I'm assuming this makes access easier but not sure
  List<Object> get props => [name, phone, email, address, password, uid];

}



//Create a bloc that creates a user opun login/sign In
//Destroy the bloc on signOut