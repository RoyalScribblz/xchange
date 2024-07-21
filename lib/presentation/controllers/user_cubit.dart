import "package:auth0_flutter/auth0_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/contracts/get_user_response.dart";
import "../../data/dtos/currency.dart";
import "../../data/repositories/user_repository.dart";
import "cubit_models/user.dart";

class UserCubit extends Cubit<User> {
  UserCubit() : super(User(null, null, null));

  Future login(Credentials credentials, Auth0 auth0) async {
    GetUserResponse? user = await UserRepository.getUser(credentials);

    user ??= await UserRepository.createUser(credentials);

    emit(User(credentials, user, auth0));
  }

  Future updateLocalCurrency(String currencyId) async {
    final Currency? currency = await UserRepository.setLocalCurrency(
      currencyId,
      state.credentials
    );

    if (currency == null || state.user == null) {
      return;
    }

    emit(User(
      state.credentials,
      GetUserResponse(
        userId: state.user!.userId,
        localCurrency: currency,
        isFrozen: state.user!.isFrozen,
        isBanned: state.user!.isBanned,
      ),
      state.auth0,
    ));
  }

  Future logout() async {
    await state.auth0?.webAuthentication(scheme: "xchange").logout();
    emit(User(null, null, null));
  }
}
