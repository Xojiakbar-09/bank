import 'package:bank_card/presentation/cubit/register_stet.dart';
import 'package:bank_card/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState(status: RegisterStatus.initial));

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(RegisterState(status: RegisterStatus.loading));
    try {
      await AuthRepository.registor(
        email: email,
        password: password,
        username: username,
      );
       emit(RegisterState(status: RegisterStatus.authentificate));
    } catch (e) {
       emit(RegisterState(status: RegisterStatus.failure));
    }
  }
}
