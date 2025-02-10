import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';

class AuthorDetailScreen extends StatelessWidget {
  final Message message;

  const AuthorDetailScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Details", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<AuthorBloc, AuthorState>(
            builder: (context, state) {
              // Find the updated message from the state
              final updatedMessage = (state is AuthorLoaded)
                  ? state.messages?.firstWhere(
                    (msg) => msg.id == message.id,
                orElse: () => message,
              )
                  : message;

              final isFavorite = (updatedMessage?.author?.fav ??false) || (message.author?.fav ?? false);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  context.read<AuthorBloc>().add(ToggleFavorite(updatedMessage));
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Author Image
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(ApiUrls.baseUrl + (message.author?.photoUrl ?? '')),
            ),
            const SizedBox(height: 16),

            // Author Name
            Text(
              message.author?.name ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Author Description
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  message.content ?? '',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
