// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:target/widget/mydetails.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:target/widget/mydetails.dart';


class DocumentScreen extends StatelessWidget {


  const DocumentScreen( {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
        // routes: {
        //   '/': (context) => const Login(/*onButtonClick*/),
        // }
    );
   
  }
}


void openLogin(BuildContext context) {
  final result = Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Login()));
  Navigator.of(context).pop(result);
}
class Login extends StatefulWidget {

  const Login({super.key});
  


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Function ios = openLogin ;
  late final MyDetails _myDetails;
  final title = 'Main page';
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void serState() {
    setState() {
      ios = openLogin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }

                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),

                child: Center(
                  child: ElevatedButton(

                    onPressed: () => {
                      if (_formKey.currentState!.validate()) {
                        // Navigate the user to the Home page
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const MyDetails())), (Route<dynamic> route) => false
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill input')),
                        )
                      }
                    },
                  child: const Text("click"),


                           // When clicked add a new Page to _page list
                           // _pages.add(_buildSecondPage());
                           // call setState to trigger rebuild for Widget

                )
                ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}

const documentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": false,
      "text": "Learn Dart 3"
    }
  ]
}
''';

