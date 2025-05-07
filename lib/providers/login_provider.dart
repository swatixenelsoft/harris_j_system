import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ApiService());
});



class LoginState {
  final bool isLoading;
  final String? error;

  LoginState({
    this.isLoading = false,
    this.error,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final ApiService apiService;

  LoginNotifier(this.apiService) : super(LoginState());


  Future<Map<String,dynamic>> login(email,password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print("customerdata $email,$password");
      final loginResponse = await apiService.login(email,password);

      state = state.copyWith(isLoading: false);
      return loginResponse;
    }
    catch (error) {
      print("error ${error.toString()}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
    };
    }
  }

}

