import '../../models/models.dart';
import '../../services/api_service.dart';

class AuthorRepository {
  final ApiService apiService;

  AuthorRepository({required this.apiService});

  Future<AuthorListResponse> fetchMessages({String? pageToken}) async {
    return await apiService.fetchMessages(pageToken: pageToken);
  }
}