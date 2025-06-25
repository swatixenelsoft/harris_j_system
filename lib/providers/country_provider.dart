import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final getCountryProvider =
    StateNotifierProvider<GetCountryNotifier, GetCountryState>((ref) {
  return GetCountryNotifier(ApiService());
});

class GetCountryState {
  final bool isLoading;
  final String? error;
  final List<String>? countryList;
  final List<String>? stateList;

  GetCountryState({
    this.isLoading = false,
    this.error,
    this.countryList,
    this.stateList,
  });

  GetCountryState copyWith({
    bool? isLoading,
    String? error,
    List<String>? countryList,
    List<String>? stateList,
  }) {
    return GetCountryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      countryList: countryList ?? this.countryList,
      stateList: stateList ?? this.stateList,
    );
  }
}

class GetCountryNotifier extends StateNotifier<GetCountryState> {
  final ApiService apiService;

  GetCountryNotifier(this.apiService) : super(GetCountryState());

  Future<void> fetchCountries(String token) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.fetchCountry(token);

      final bool status = response['status'] ?? false;
      if (status) {
        final List<String> countries =
            List<String>.from(response['countries'] ?? []);
        state = state.copyWith(isLoading: false, countryList: countries);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Unknown error',
        );
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  Future<void> fetchStates(String country, String token) async {
    print('countrssy $country');
    // state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.fetchState(country, token);
      print('responsestate $response');
      final bool status = response['status'] ?? false;
      if (status) {
        final List<String> states = List<String>.from(response['states'] ?? []);
        state = state.copyWith(stateList: states);
      } else {
        state = state.copyWith(
          // isLoading: false,
          error: response['message'] ?? 'Unknown error',
        );
      }
    } catch (error) {
      print('error ${error.toString()}');
      state = state.copyWith(
        // isLoading: false,
        error: error.toString(),
      );
    }
  }
}
