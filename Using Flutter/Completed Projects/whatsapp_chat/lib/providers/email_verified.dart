import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailVerifiedProviderNotifier extends StateNotifier<bool> {
  EmailVerifiedProviderNotifier() : super(false);

  void setVerified(bool isSaved) {
    state = isSaved;
  }
}

final emailVerifiedProvider =
    StateNotifierProvider<EmailVerifiedProviderNotifier, bool>(
        (ref) => EmailVerifiedProviderNotifier());
