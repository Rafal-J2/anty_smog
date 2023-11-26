import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/get_api.dart';
import 'app_events.dart';
import 'app_states.dart';

class UserBloc extends Bloc<UserEvent, UserSate> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository, {required UserRepository repository}) : super(UserLoadingState()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoadingState());
    });
  }
}

