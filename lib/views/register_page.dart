import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children:[
          Container(
            height: height,
            width: width,
            decoration:const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login2.jpeg"),
                  fit: BoxFit.cover),
            ),
            child: Container(
              margin:const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // First Name
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'First Name',  border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4)
                    )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your  name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email',  border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4)
                    )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';

                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)
                    )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),

                 const SizedBox(
                    height: 30,
                  ),

                  ElevatedButton(onPressed: () async {
                    var name = nameController.text;
                    var email = emailController.text;
                    var password = passwordController.text;

                    if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty ) {
                      var  auth = FirebaseAuth.instance;
                      auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    }
                  }, child:const  Text("Register"))

                ],
              ),
                      ),
            ),
          ),
      ]
      ),
    );
  }
}
