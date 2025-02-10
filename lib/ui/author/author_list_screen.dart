import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';
import '../screens.dart';

class AuthorListScreen extends StatefulWidget {
  const AuthorListScreen({super.key});

  @override
  State<AuthorListScreen> createState() => _AuthorListScreenState();
}

class _AuthorListScreenState extends State<AuthorListScreen> {

  final ScrollController _scrollController = ScrollController();
  List<Message> authorsList = [];
  String pageToken = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    context.read<AuthorBloc>().add(const FetchAuthors());
  }
  void _scrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if(pageToken.isNotEmpty) {
        context.read<AuthorBloc>().add(FetchAuthors(pageToken: pageToken));
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authors'),
      ),
      body: BlocBuilder<AuthorBloc, AuthorState>(
        builder: (context, state) {
          if (state is AuthorLoading) {
            if (state.pagination ?? false) {
              isLoading = true;
            } else {
              return const Center(
                child: SizedBox(
                    height: 100,
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color:  Color(0xFF081B63),
                      ),
                    )),
              );
            }
          } else if (state is AuthorError) {
            isLoading =false;
            return Center(child: Text(state.message));
          } else if (state is AuthorLoaded) {
            isLoading =false;
            pageToken = state.nextPageToken??'';
            if(state.pagination??false) {
              if ((state.nextPageToken ?? '').isNotEmpty) {
                authorsList.addAll(state.messages ?? []);
              } else {
                authorsList = state.messages ?? [];
              }
            }else{
              authorsList = state.messages ?? [];
            }
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: TextField(
                  onChanged: (query) {
                    context.read<AuthorBloc>().add(SearchAuthors(query));
                  },
                  decoration: InputDecoration(


                    hintText: "Search...",
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              authorsList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemCount: authorsList.length+1,
                        itemBuilder: (context, index) {
                          if (index < authorsList.length) {
                            final message = authorsList[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                onTap: () {
                                  // In AuthorListScreen
                                  // In AuthorListScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => BlocProvider.value(
                                        value: context.read<AuthorBloc>(),
                                        child: AuthorDetailScreen(message: message),
                                      ),
                                    ),
                                  );



                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      ApiUrls.baseUrl +
                                          (message.author?.photoUrl ?? '')),
                                ),
                                title: Text(
                                  message.author?.name ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(message.yearsAgo),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        message.author?.fav ?? false
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: message.author?.fav ?? false
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        // Toggle favorite status
                                        context.read<AuthorBloc>().add(ToggleFavorite(message));
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20),
                                        ),
                                        side: const BorderSide(
                                            color: Colors.red),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        // Delete author from the list
                                        _showDeleteDialog(context, message);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }else{
                            return Visibility(
                              visible: isLoading,
                              child: const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: CupertinoActivityIndicator(
                                      color: Color(0xFF081B63),
                                    ),
                                  )),
                            );
                          }
                        },
                      ),
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Message? message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<AuthorBloc>(context),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Delete Author',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        ApiUrls.baseUrl + (message?.author?.photoUrl ?? ''),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message?.author?.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message?.yearsAgo ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Are you sure you want to delete this author?'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  context.read<AuthorBloc>().add(DeleteAuthor(message));
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}