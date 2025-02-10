part of 'author_bloc.dart';

abstract class AuthorEvent extends Equatable {
  const AuthorEvent();

  @override
  List<Object> get props => [];
}

class FetchAuthors extends AuthorEvent {
  final String? pageToken;

  const FetchAuthors({this.pageToken});

  @override
  List<Object> get props => [pageToken ?? ''];
}

class SearchAuthors extends AuthorEvent {
  final String query;
  const SearchAuthors(this.query);
}

class DeleteAuthor extends AuthorEvent {
  final Message? message;
  const DeleteAuthor(this.message);
}

class ToggleFavorite extends AuthorEvent {
  final Message? message;
  const ToggleFavorite(this.message);
}