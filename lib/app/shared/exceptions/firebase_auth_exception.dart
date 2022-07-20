import 'failure_exception.dart';

class FirebaseAuthErros implements Failure {
  static const Map<String, String> errors = {
    // errors auth signInWithEmailAndPassword
    "invalid-email": "Email inválido, tente novamente.",
    "user-disabled": "Usuário desativado, fale com um administrador.",
    "user-not-found": "Usuário não localizado, verifique seu email e senha.",
    "wrong-password": "Usuário e/ou senha inválidos, tente novamente.",
    "email-already-in-use": "Esta conta já existe.",

    // errors auth sendPasswordResetEmail
    // "user-not-found": "",
    // "invalid-email": "",
    "missing-android-pkg-name": "Erro ao obter o pacote para android",
    "missing-continue-uri":
        "Uma URL contínua deve ser fornecida na solicitação.",
    "missing-ios-bundle-id":
        "Um ID do pacote iOS deve ser fornecido se um ID da App Store for fornecido.",
    "invalid-continue-uri":
        "A URL de continuação fornecida na solicitação é inválida.",
    "unauthorized-continue-uri":
        "O domínio da URL de continuação não está na lista branca. Lista branca do domínio no console Firebase.",

    "email-not-found": "Email não encontrado.",
    "invalid-password": "Senha não confere, tente novamente.",
    "OPERATION_NOT_ALLOWED": "Operação não permitida.",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Muitas tentativas executadas, tente novamente mais tarde.",
    "weak-password": "Melhore sua senha.",
  };

  final String key;

  FirebaseAuthErros(this.key) : super();

  @override
  String toString() {
    return errors[key] ??
        'Ocorreu um erro inesperado, informe o administrador.';
  }

  @override
  String get errorMessage =>
      errors[key] ?? 'Ocorreu um erro inesperado, informe o administrador.';
}
