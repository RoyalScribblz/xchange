import "package:auth0_flutter/auth0_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/contracts/get_user_response.dart";
import "../../data/repositories/user_repository.dart";
import "cubit_models/user.dart";

class UserCubit extends Cubit<User> {
  UserCubit() : super(User(null, null));

  Future login(Credentials credentials) async {
    GetUserResponse? user =
        await UserRepository.getUser(credentials.user.sub);

    user ??= await UserRepository.createUser(credentials.user.sub);

    emit(User(credentials, user));
  }
}
