class Message {

  Message( {
    required this.id,
    required this.isMine,
    required this.user_from,
    required this.content,
    required this.created_at,
    required this.user_to,
  });

  /// ID of the message
  final String id;

  /// ID of the user who posted the message
  final String user_from;
  final String user_to;
  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final DateTime created_at;

  /// Whether the message is sent by the user or not.
  final bool isMine;

  Message.fromMap({
    required Map<String, dynamic> map,
    required String myUserId
  })  : id = map['id'],
        user_from = map['user_from'],
        user_to = map['user_to'],
        content = map['content'],
        created_at = DateTime.parse(map['created_at']),
        isMine = myUserId == map['user_from'];
}