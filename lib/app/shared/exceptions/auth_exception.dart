import 'failure_exception.dart';

class NoDataFound extends Failure {}

class NoUserFound extends Failure {
  NoUserFound()
      : super(errorMessage: "Os dados de usuário não foram localizados.");
}

class ErrorGoogleSignIn extends Failure {
  ErrorGoogleSignIn()
      : super(errorMessage: "Ocorreu um erro ao fazer login no Google.");
}

class NoInternetConnection extends Failure {
  NoInternetConnection()
      : super(errorMessage: "Sem conexão com a internet no momento.");
}

class MembersListNoInternetConnection extends NoInternetConnection {}

class MembersListError extends Failure {
  MembersListError(StackTrace stackTrace, String label, dynamic exception,
      String errorMessage)
      : super(
            stackTrace: stackTrace,
            label: label,
            exception: exception,
            errorMessage: errorMessage);
}
