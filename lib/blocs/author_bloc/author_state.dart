part of 'author_bloc.dart';

abstract class AuthorState extends Equatable {
  const AuthorState();

  @override
  List<Object> get props => [];
}

class AuthorInitial extends AuthorState {}

class AuthorLoading extends AuthorState {
  final bool? pagination;
  const AuthorLoading({ this.pagination});

  @override
  List<Object> get props => [pagination ?? false];
}


class AuthorLoaded extends AuthorState {
  final List<Message>? messages;
  final String? nextPageToken;
  final bool? pagination;


  const AuthorLoaded({required this.messages, this.nextPageToken,this.pagination});

  @override
  List<Object> get props => [messages??[], nextPageToken ?? '',pagination??false];
}

class AuthorError extends AuthorState {
  final String message;

  const AuthorError({required this.message});

  @override
  List<Object> get props => [message];
}