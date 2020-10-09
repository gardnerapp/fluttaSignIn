import 'package:flutter/material.dart';
import 'package:beech_sign_in/styles/text.dart';
import 'package:beech_sign_in/backend/admin.dart';
import 'package:beech_sign_in/main.dart';

//TODO Obfuscate Password Text

class Authenticate extends StatefulWidget {
  static Route route(){
    return MaterialPageRoute<void>(builder: (_) => Authenticate());
  }

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return Container(child: SignIn(toggleView: toggleView,));
    }
    else{
      return Container(child: SignUp(toggleView: toggleView));
    }
  }
}


class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  //Creates a global key that UNiquily ID's this form
  final _formKey = GlobalKey<FormState>();

  String email;
  String phone;
  String name;
  String address;
  String password;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Sign Up",
              style: TextStyle(color: Colors.yellow),
            ),
            elevation: 16.0,
            backgroundColor: Colors.red,
            titleSpacing: 25.0,
            leading: IconButton(icon: Icon(Icons.repeat, size: 30.0,),
              onPressed: ()=> widget.toggleView(),
              splashColor: Colors.yellow,
            )
        ),
        body:
        Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView(
              children: [
                Center(child: Text("Create Your Account Here: ", style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold
                ),),),
                ///Name
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Name"),
                  validator: (val) => val.isEmpty ? "Enter Your Name" : null,
                  onChanged: (val) => setState((){
                    name = val;
                  }),
                ),
                ///Email
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                  validator: (val) => val.isEmpty ? "Please Enter your Email" : null,
                  onChanged: (val) => setState((){
                    email = val;
                  }),
                ),
                ///Phone
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Phone Number "),
                  validator: (val) => val.length <= 6 ? "Please Enter a Proper Phone Number  " : null,
                  onChanged: (val) => setState((){
                    phone = val;
                  }),
                ),
                ///address
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Address"),
                  validator: (val) => val.isEmpty ? "For Delivery Purposes Enter Your Address" : null,
                  onChanged: (val) => setState((){
                    address = val;
                  }),
                ),
                SizedBox(height: 20.0),
                ///Password
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(hintText: "Password"),
                  validator: (val) => val.length < 6 ? "Password Must be at least 6 Characters " : null,
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 50,
                  width: 200,
                  child: RaisedButton.icon(
                    splashColor: Colors.red,
                    color: Colors.white,
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        bool result = await Service().createUser(
                            name: name,
                            phone: phone,
                            email: email,
                            address: address,
                            password: password
                        );
                        if(result == false){

                          ///Snack did not show, we did not get the result from the server we wanted but
                          ///the users were created
                          ///Auth token was not shown

                        }
                        else if(result == true){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                        }
                      }
                    },
                    icon: Icon(Icons.phonelink_setup, size: 45.0, color: Colors.red,),
                    label: Text("Sign Up!", style: TextStyle(color: Colors.red, fontSize: 25.0, ),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  String email;
  String password;

  //email and pass
  //await correct status codes
  //Create User
  //proceed to home

  //Validator will submit then check if the email matches the password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.repeat, size: 30.0,),
          onPressed: ()=> widget.toggleView(),
          splashColor: Colors.yellow,
        ),
        elevation: 16.0,
        title: Text('Sign In',
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                  validator: (val) =>
                      val.isEmpty ? "Incorrect Email or Password " : null,
                  onChanged: (val) => setState(() {
                    email = val;
                  }),
                ),   SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration:
                      textInputDecoration.copyWith(hintText: "Password",),
                  validator: (val) =>
                      val.isEmpty ? "Incorrect  Email or Password" : null,
                  onChanged: (val) => setState(() {
                    password = val;
                  }),
                ), SizedBox(height: 20.0),
                Container(
                  height: 50,
                  width: 200,
                  child: RaisedButton.icon(
                    splashColor: Colors.red,
                    color: Colors.white,
                    onPressed: () async {

                    },
                    icon: Icon(Icons.phonelink_setup, size: 45.0, color: Colors.red,),
                    label: Text("Sign In", style: TextStyle(color: Colors.red, fontSize: 25.0, ),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                RaisedButton.icon(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Recovery()));
                },
                    icon: Icon(Icons.email, size: 45.0, color: Colors.red),
                    label: Text("Reset Password", style: TextStyle(color: Colors.red, fontSize: 25.0, )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  color: Colors.white,
                  splashColor: Colors.red,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class Recovery extends StatefulWidget {
  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final _formKey = GlobalKey<FormState>();
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Account Recovery"),
        elevation: 15.0,
        leading: IconButton(icon: Icon(Icons.keyboard_backspace, color: Colors.white, size: 30,), onPressed: (){
          Navigator.pop(context);
    }),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                //Validation didn't work
                validator: (val) => val.isEmpty? "Please Enter Your Eamil" : null,
                onChanged: (val) =>
                setState((){
                  email = val;
                }),
              ),
              SizedBox(height:20.0 ),
              RaisedButton.icon(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RecoveryConfirmation(email: email)));
              },
                icon: Icon(Icons.cloud_upload, size: 45.0, color: Colors.red),
                label: Text("Submit", style: TextStyle(color: Colors.red, fontSize: 25.0, )),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Colors.white,
                splashColor: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RecoveryConfirmation extends StatelessWidget {
 String email;
  RecoveryConfirmation({this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 16.0,
      ),
      body: ListView(
        children: <Widget>[
          Expanded(child: Text("Account Recovery Sent To ${email}", style: TextStyle(fontSize: 20.0, color: Colors.black),)),
          SizedBox(height: 20.0,),
          RaisedButton.icon(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            icon: Icon(
              Icons.home,
              color: Colors.red,
              size: 45.0,
            ),
            label: Text("Continue",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25.0,
                )),
            splashColor: Colors.red,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          )
        ],
      ),
    );
  }
}
