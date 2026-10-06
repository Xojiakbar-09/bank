enum RegisterStatus { initial, loading, failure, authentificate }

class RegisterState {
  final RegisterStatus status;
  const RegisterState({required this.status});
}
