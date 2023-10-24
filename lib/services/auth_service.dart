import 'package:chat_app/helper/helper_funtion.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
    Future loginWithUserNameandPassword(
       String email, String password) async {
    try {
      // ignore: unused_local_variable
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
        return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registerUserWitheEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      await DatabaseService(uid: user.uid).saveingUserData(fullName, email);

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signout
  Future sigout() async {
    try {
      await HelperFuntions.saveUserLoggedInStatus(false);
      await HelperFuntions.saveUserEmailSF("");
      await HelperFuntions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  void logout() {}
}
