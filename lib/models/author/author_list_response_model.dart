
class AuthorListResponse {
  final int? count;
  final String? pageToken;
  final List<Message>? messages;

  AuthorListResponse({
    required this.count,
    required this.pageToken,
    required this.messages,
  });

  factory AuthorListResponse.fromJson(Map<String, dynamic> json) {
    return AuthorListResponse(
      count: json['count'],
      pageToken: json['pageToken'],
      messages: List<Message>.from(
        json['messages'].map((message) => Message.fromJson(message)),
      ),
    );
  }
}

class Message {
  final int? id;
  final Author? author;
  final String? updated;
  final String? content;

  Message({
    required this.id,
    required this.author,
    required this.updated,
    required this.content,
  });
  Message copyWith({
    int? id,
    Author? author,
    String? updated,
    String? content,
  }) {
    return Message(
      id: id ?? this.id,
      author: author ?? this.author,
      updated: updated ?? this.updated,
      content: content ?? this.content,
    );
  }
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      author: Author.fromJson(json['author']),
      updated: json['updated'],
      content: json['content'],
    );
  }

  // Getter to calculate years since the message was updated
  String get yearsAgo {
    if (updated == null) return 'Unknown';

    DateTime updatedDate = DateTime.parse(updated!);
    DateTime currentDate = DateTime.now();

    int yearsDifference = currentDate.year - updatedDate.year;

    // Adjust if the current date is before the updated date's anniversary
    if (currentDate.month < updatedDate.month ||
        (currentDate.month == updatedDate.month && currentDate.day < updatedDate.day)) {
      yearsDifference--;
    }

    return '$yearsDifference years ago';
  }
}

class Author {
  final String? name;
  final String? photoUrl;
  final bool? fav;

  Author({
    required this.name,
    required this.photoUrl,
    required this.fav,
  });
  Author copyWith({
    final String? name,
    final String? photoUrl,
    final bool? fav,
  }) {
    return Author(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      fav: fav ?? this.fav,
    );
  }
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      fav: json['fav']!=null?true:false,
    );
  }
}