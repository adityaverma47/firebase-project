import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // File? fileImage;
 String selectedImagePath ='';
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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
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
                      selectedImagePath == "" ?Image.asset("assets/images/login.jpeg", height: 200,width: 200,fit: BoxFit.fill,) :Image.file(File(selectedImagePath),filterQuality: FilterQuality.low,height: 200,width: 200,fit: BoxFit.fill,) ,
                      SizedBox(height: 10,),

                      ElevatedButton(onPressed: () async {
                             // _pickFile();
                    var  selectedPath = await _imagePicker();
                    if(selectedPath != ""){
                      Navigator.pop(context);
                      setState(() {
                      });

                    }else{
                      print("No image selected");
                    }
                      }, child: Text("Select Image",style: TextStyle(fontSize: 18),)),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4))),
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
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4))),
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
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          var email = emailController.text;
                          var password = passwordController.text;

                          if (_formKey.currentState!.validate()) {
                            if (email.isNotEmpty && password.isNotEmpty) {
                              login();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                            } else {
                              log("Login failed");
                            }
                          } else {
                            log("user not exist");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4)),
                          width: width,
                          height: 50,
                          child: const Center(
                              child: Text(
                            "Login",
                            style: TextStyle(fontSize: 25),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Do you have an account? ",
                            style: TextStyle(fontSize: 18),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      ),

                      SizedBox(height: 20,),

                      InkWell(
                          onTap: (){
                          googleLogin();
                          },
                          child: Text("Google", style: TextStyle(fontSize: 20),))


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    try{
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      print("Token: ${auth.currentUser}");
      final User? user = auth.currentUser;
      final uid = user?.uid;
      print("Uid : ${uid.toString()}");
    } on FirebaseAuthException catch(e){
      if(e.code == 'user not found'){
        showToast("User does not exist");
      } else if(e.code == 'wrong password'){
        showToast("Password not matched");
      }
    }
  }

  void googleLogin() async{

    try{
      final GoogleSignInAccount? googleUser =await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken,
          accessToken: googleAuth?.accessToken
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      print("Successfully Login: $credential");
    } catch(e){
      print("Exception: ${e.toString()}");
    }
  }

  // void _pickFile() async{
  //
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //
  //   if(result != null && result.files.single.path != null) {
  //
  //     PlatformFile pfile = result.files.first;
  //     print(pfile.name);
  //     print(pfile.size);
  //     print(pfile.path);
  //     print(pfile.extension);
  //
  //     File _file = File(result.files.single.path!);
  //
  //     setState(() {
  //       fileText = _file.path as File?;
  //     });
  //   }
  //
  // }

  _imagePicker() async{

    final ImagePicker picker = ImagePicker();

    final XFile? file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    print("File Path ${file?.path}");

    if(file != null){
      return file.path;
    }
     else{
       return null;
    }
  }



  void showToast(String txt){
    Fluttertoast.showToast(
        msg: txt,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red
    );
  }
}
