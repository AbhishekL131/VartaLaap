import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../components/showSnackBar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseAuthMethods(this._auth);

  // STATE PERSISTENCE
  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // Email sign up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);

      // Store user data in Firestore
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'Name': name,
        'Email': email,
        'Password': password,
        'profile_picture': '', // Initialize with an empty string
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      showSnackBar(context, e.message!);
    } catch (e) {
      print('Error storing user data: $e');
      showSnackBar(context, 'Error storing user data: $e');
    }
  }

  // Email login
  Future<bool> LoginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      return false;
    }
  }

  // Email verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, "Email verification sent!");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Delete account
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackBar(context, "Password reset email sent!");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Upload profile picture


  // Retrieve user data
  Future<DocumentSnapshot?> getUserData() async {
    final doc = await _firestore.collection('Users').doc(_auth.currentUser!.uid).get();
    return doc.exists ? doc : null;
  }


}
