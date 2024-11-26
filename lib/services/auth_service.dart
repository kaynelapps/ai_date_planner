import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

class AuthService {
  static const String _emailKey = 'user_email';
  static const String _nicknameKey = 'user_nickname';
  static const String _isLoggedInKey = 'is_logged_in';


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkNicknameAvailability(String nickname) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  Future<bool> signUp(String email, String password, String nickname) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'nickname': nickname,
      });
      await _saveUserSession(email, nickname);
      return true;
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch the user's nickname from Firestore
      String? nickname = await _getNicknameFromFirestore(email);

      // If the nickname is null or empty, we need to prompt the user to set one
      if (nickname == null || nickname.isEmpty) {
        // Return true, but the calling function should check if a nickname exists
        return true;
      }

      // Save the user session with the retrieved nickname
      await _saveUserSession(email, nickname);
      return true;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      // Clear any existing sign-in state
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Get or create user document
        final userDocRef = _firestore.collection('users').doc(user.uid);
        final userDoc = await userDocRef.get();

        final userData = {
          'email': user.email,
          'lastSignIn': FieldValue.serverTimestamp(),
          'provider': 'google',
          'uid': user.uid,
          'displayName': user.displayName,
        };

        if (userDoc.exists) {
          final existingData = userDoc.data()!;
          if (existingData.containsKey('nickname')) {
            userData['nickname'] = existingData['nickname'];
          }
        }

        // Update user data
        await userDocRef.set(userData, SetOptions(merge: true));

        // Save session if nickname exists
        if (userData.containsKey('nickname')) {
          await _saveUserSession(user.email ?? '', userData['nickname'] as String);
        }

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Google Sign In Error: $e');
      return false;
    }
  }


  Future<bool> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print('Apple credential obtained: ${credential.identityToken != null}');

      final oAuthProvider = OAuthProvider('apple.com');
      final credentialFirebase = oAuthProvider.credential(
        idToken: credential.identityToken,
        rawNonce: rawNonce,
      );

      print('Firebase credential created');

      final UserCredential userCredential = await _auth.signInWithCredential(credentialFirebase);
      final User? user = userCredential.user;

      print('Firebase user signed in: ${user != null}');

      if (user != null) {
        String? nickname = await _getNicknameFromFirestore(user.email ?? '');
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'nickname': nickname,
        }, SetOptions(merge: true));
        await _saveUserSession(user.email ?? '', nickname ?? '');
        return true;
      }
      return false;
    } catch (e) {
      print('Error signing in with Apple: $e');
      if (e is SignInWithAppleAuthorizationException) {
        print('SignInWithAppleAuthorizationException code: ${e.code}');
      }
      return false;
    }
  }

  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_nicknameKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<String?> getCurrentUserNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nicknameKey);
  }

  Future<void> _saveUserSession(String email, String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_nicknameKey, nickname);
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<String?> _getNicknameFromFirestore(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.get('nickname') as String?;
      }
    } catch (e) {
      print('Error getting nickname from Firestore: $e');
    }
    return null;
  }

  Future<void> updateUserNickname(String email, String nickname) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await _firestore.collection('users').doc(userId).update({
          'nickname': nickname,
        });
        await _saveUserSession(email, nickname);
      }
    } catch (e) {
      print('Error updating nickname: $e');
    }
  }

  Future<String?> getCurrentUserCity() async {
    final userEmail = await getCurrentUserEmail();
    if (userEmail != null) {
      final userDoc = await _firestore.collection('users').where('email', isEqualTo: userEmail).limit(1).get();
      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs.first.get('city') as String?;
      }
    }
    return null;
  }

  Future<void> blockUser(String userIdToBlock) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'blockedUsers': FieldValue.arrayUnion([userIdToBlock]),
      });
    }
  }

  Future<List<String>> getBlockedUsers() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final doc = await _firestore.collection('users').doc(currentUser.uid).get();
      return List<String>.from(doc.data()?['blockedUsers'] ?? []);
    }
    return [];
  }

  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete user authentication account
        await user.delete();

        // Sign out the user
        await signOut();
      }
    } catch (e) {
      print('Error deleting account: $e');
      throw e;
    }
  }

  Future<void> changeNickname(String newNickname) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'nickname': newNickname,
      });
      await _saveUserSession(user.email ?? '', newNickname);
    }
  }

  Future<void> changeEmail(String newEmail) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateEmail(newEmail);
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
      });
      await _saveUserSession(newEmail, await getCurrentUserNickname() ?? '');
    }
  }

  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  Future<bool> hasNickname(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists && doc.get('nickname') != null && doc.get('nickname') != '';
  }

  Future<void> saveNickname(String uid, String nickname) async {
    await _firestore.collection('users').doc(uid).set({
      'nickname': nickname,
    }, SetOptions(merge: true));
    await _saveUserSession(await getCurrentUserEmail() ?? '', nickname);
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}