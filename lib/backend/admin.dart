import 'dart:convert';
import 'models.dart';
import 'package:beech_sign_in/backend/address.dart';
import 'package:http/http.dart' as http;

class Service{

  Future<bool> createUser(
      {String name,
      String phone,
      String email,
      String address,
      String password}) async {
    Map<String, String> body = {
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
      "password": password
    };

    try {
      final http.Response response = await http.post(createUserURL,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, Map>{"customer": body}));
      print("Response Code => ${response.statusCode.toString()}");
      //Returns True if Response Works
      if (response.statusCode != 200 | 302) {
      //  User user = setUserFromSignUp(body);
       // print(user.name);
        print("body ${response.body}");
        print("headers ${response.headers}");
        return true;
        //TODO Place User Object into provider
      }
      //What Will code be With failed Validations etc, may have to make other conditionals
      //for these cases
      else {
        return false;
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      return false;
    }
  }

  User setUserFromSignUp(Map<String, String> body) {
    //If body != null then create new user from the body else return null
    return body != null
        ? User(
            name: body["name"],
            phone: body["phone"],
            email: body["email"],
            address: body["address"],
            password: body["password"])
        : null;
  }

  User setUserFromSignIn(){
    //Takes email & password
    //Sees if response is correct
    //creates user object by getting all of the info from the database
  }

  //Destorys Local User
  User logOut(User user) {
    return user = null;
  }



}





