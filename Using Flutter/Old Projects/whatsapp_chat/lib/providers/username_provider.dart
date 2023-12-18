import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameProvider extends StateNotifier<bool> {
  UsernameProvider() : super(false);

  void setUsername(bool isSaved) {
    state = isSaved;
  }
}

final usernameProvider =
    StateNotifierProvider<UsernameProvider, bool>((ref) => UsernameProvider());
