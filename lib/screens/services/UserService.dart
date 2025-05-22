import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/UserModel.dart';

class UserService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registration(UserModel userModel) async {
    print(userModel);

    try {
      await _auth.signInWithEmailAndPassword(
        email: userModel.email, password: userModel.password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }

    
  }
  /*

  UserModel(
      email: user!.email,
      password: user!.password,
      uid: user.uid,
    );


  Stream<UserModel> get user {
    return _auth
        .authStateChanges()
        .asyncMap((user) => UserModel(email: user!.email, password: user!.password, uid: user!.uid));
  }

  Future<UserModel> auth(UserModel userModel) async {
    UserCredential userCredential;

    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: userModel.email.toString() ,
        password: userModel.password.toString(),
      );
    } catch (e) {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: userModel.email.toString(),
        password: userModel.password.toString(),
      );
    }

    userModel.setUid = userCredential.user!.uid;

    return userModel;
  }*/
}
