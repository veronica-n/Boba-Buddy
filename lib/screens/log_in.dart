import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myflutter_app/screens/options_page.dart';



class LogInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LogInScreenState();
}

enum FormType{
  login,
  register
}

class _LogInScreenState extends State<LogInScreen> {

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in: ${user.uid}');
        }else{
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          print('Register user: ${user.uid}');
        }
      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("Boba Buddy"),
        backgroundColor: Colors.pink[300],
      ),
      body:

      new Container(
        padding: EdgeInsets.all(16),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:   imageIn() + imageIn2() + start()
          ),

        )
      )

    );
  }

  List <Widget> imageIn() {
    return[
    Image.asset('assets/Images/GIF.gif',height: 400, width: 400,)
    ];

  }

  List <Widget> imageIn2() {
    return[
      Image.asset('assets/Images/boba buddy text.jpg',height: 110, width: 65,)
    ];

  }

  List <Widget> start() {
    return[
      new RaisedButton(
        child: new Text('Click here to start a delicious experience!', style: new TextStyle(fontSize: 30, color: Colors.pinkAccent.withOpacity(0.8)), textAlign: TextAlign.center,),
        onPressed: () { navigateToQuiz(context);},
      ),
    ];

  }


  Future navigateToQuiz(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BobaQuiz()));
  }


  List <Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Please write your email'),
        validator: (value) => value.isEmpty ? 'Email can not be empty!' : null,
        onSaved: (value) => _email = value,
      ),

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Please write your password'),
        validator: (value) => value.isEmpty ? 'Password can not  be empty' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
              'Create an account', style: new TextStyle(fontSize: 20)),
          onPressed: moveToRegister,
        ),
      ];
    } else{
      return [
        new RaisedButton(
          child: new Text('Create an account', style: new TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
              'Have an account? Login', style: new TextStyle(fontSize: 20)),
          onPressed: moveToLogin,
        ),
      ];

    }
  }
}