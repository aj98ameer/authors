import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../repository/repositories.dart';

part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final AuthorRepository authorRepository;
  List<Message> allMessages = [];
  String pageToken ='';

  AuthorBloc(this.authorRepository) : super(AuthorInitial()) {
    on<FetchAuthors>((event, emit) async {
      await _onFetchAuthors(event, emit);
    });
    on<SearchAuthors>((event, emit) async {
      await _onSearchAuthors(event, emit);
    }); on<DeleteAuthor>((event, emit) async {
      await _onDeleteAuthor(event, emit);
    });
    on<ToggleFavorite>((event, emit) async {
      await _onToggleFavorite(event, emit);
    });

  }

  Future<void> _onFetchAuthors(FetchAuthors event, Emitter<AuthorState> emit) async {
      emit(AuthorLoading(pagination:(event.pageToken??'').isNotEmpty ));
    try {
      final authorListResponse = await authorRepository.fetchMessages(pageToken: event.pageToken);
      allMessages.addAll(authorListResponse.messages ?? []);
      pageToken = authorListResponse.pageToken ?? '';
      emit(AuthorLoaded(messages: authorListResponse.messages,nextPageToken: authorListResponse.pageToken,pagination: true));
    } catch (e) {
      emit(AuthorError(message: e.toString()));
    }
  }

  Future<void> _onSearchAuthors(
      SearchAuthors event, Emitter<AuthorState> emit) async{
    final query = event.query.toLowerCase();
    final filteredMessages = allMessages.where((message) {
      final authorName = message.author?.name?.toLowerCase() ?? '';
      return authorName.contains(query);
    }).toList();
    emit(AuthorLoaded(messages: filteredMessages,nextPageToken: pageToken,pagination: false));
  }

  Future<void> _onDeleteAuthor(
      DeleteAuthor event, Emitter<AuthorState> emit) async{
    final updatedMessages = List<Message>.from(allMessages);

    updatedMessages.remove(event.message);
    allMessages.clear();
    allMessages.addAll(updatedMessages);
    emit(AuthorLoaded(messages: updatedMessages,nextPageToken: pageToken,pagination: false));
  }

  Future<void>  _onToggleFavorite(
      ToggleFavorite event, Emitter<AuthorState> emit)async {

    final message = event.message;
    final updatedMessage = message?.copyWith(
      author: message.author?.copyWith(
        fav: !(message.author?.fav ?? false),
      ),
    );
    final index = allMessages.indexOf(message!);
    if (index != -1) {
      final updatedMessages = List<Message>.from(allMessages);
      updatedMessages[index] = updatedMessage!;

      allMessages.clear();
      allMessages.addAll(updatedMessages);

      emit(AuthorLoaded(messages: updatedMessages,nextPageToken: pageToken,pagination: false));
    }
  }
}