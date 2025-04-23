import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_connect/core/models/account.dart';

class UserAccountCollection {
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('user-accounts');

  Future<void> addUser(Account user) async {
    print("Attempting to add user with ID: ${user.idUser}");
    print("User data: ${user.toJson()}");

    if (user.idUser.isEmpty) {
      print("Error: User ID is null or empty!");
      return;
    }

    try {
      // Add new account
      await _userCollection.doc(user.idUser).set(user.toJson());
      print(
        "Firestore set command executed for user: ${user.idUser}. Check Firestore Console.",
      );
    } catch (e) {
      print("Error adding user to Firestore: $e");
      return;
    }
  }

  Future<Account?> getUserById(String id) async {
    try {
      final DocumentSnapshot snapshot = await _userCollection.doc(id).get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        return Account.fromJson(data);
      } else {
        print("User with ID $id not found or data is null.");
        return null;
      }
    } catch (e) {
      print("Error fetching user with ID $id: $e");
      return null;
    }
  }

  Future<void> updateUser(Account user) async {
    try {
      await _userCollection.doc(user.idUser).update(user.toJson());
      print("User with ID ${user.idUser} updated successfully.");
    } catch (e) {
      print("Error updating user: $e");
    }
  }
}
