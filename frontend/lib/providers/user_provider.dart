import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import 'auth_provider.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserService(apiClient: apiClient);
});

final userCreationProvider = StateNotifierProvider<UserCreationNotifier, AsyncValue<User?>>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserCreationNotifier(userService);
});

class UserCreationNotifier extends StateNotifier<AsyncValue<User?>> {
  final UserService _userService;

  UserCreationNotifier(this._userService) : super(const AsyncValue.data(null));

  Future<bool> createUser(CreateUserRequest request) async {
    state = const AsyncValue.loading();
    try {
      final user = await _userService.createUser(request);
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
