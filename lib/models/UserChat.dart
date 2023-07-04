import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuts/utils/globals.dart';

class UserChat {
  final String id;
  final String photoUrl;
  final String nickname;
  final String aboutMe;

  const UserChat(
      {required this.id,
      required this.photoUrl,
      required this.nickname,
      required this.aboutMe});

  Map<String, String> toJson() {
    return {
      Globals.nickname: nickname,
      Globals.aboutMe: aboutMe,
      Globals.photoUrl: photoUrl,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String aboutMe = "";
    String photoUrl = "";
    String nickname = "";
    try {
      aboutMe = doc.get(Globals.aboutMe);
    } catch (e) {}
    try {
      photoUrl = doc.get(Globals.photoUrl);
    } catch (e) {}
    try {
      nickname = doc.get(Globals.nickname);
    } catch (e) {}
    return UserChat(
      id: doc.id,
      photoUrl: photoUrl,
      nickname: nickname,
      aboutMe: aboutMe,
    );
  }
}
