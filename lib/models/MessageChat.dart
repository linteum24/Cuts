import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuts/utils/globals.dart';

class MessageChat {
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;
  final int type;

  const MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      Globals.idFrom: this.idFrom,
      Globals.idTo: this.idTo,
      Globals.timestamp: this.timestamp,
      Globals.content: this.content,
      Globals.type: this.type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(Globals.idFrom);
    String idTo = doc.get(Globals.idTo);
    String timestamp = doc.get(Globals.timestamp);
    String content = doc.get(Globals.content);
    int type = doc.get(Globals.type);
    return MessageChat(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        type: type);
  }
}
