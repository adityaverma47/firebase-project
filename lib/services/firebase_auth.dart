import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {

  createWithEmailAndPassword(String emailAddress, String passwordAddress) {

    try {
      final auth =  FirebaseAuth.instance;
      auth.createUserWithEmailAndPassword(email: emailAddress, password: passwordAddress);
    } on FirebaseAuthException catch(e) {
      if(e.code == 'weak-password') {
        print("Password is too weak");
      } else if(e.code == 'email-already-in-use') {
        print("Email already exists");
      }
    } catch (e){
      print("failed ${e.toString()}");
    }
  }

  signWithEmailAndPassword(String emailAddress, String passwordAddress) async{

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress, password: passwordAddress);
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        print("No user found");
      } else if(e.code == 'wrong-password'){
        print("password does not matched");
      }
    }catch(e){
      print("failed ${e.toString()}");
    }

  }

}