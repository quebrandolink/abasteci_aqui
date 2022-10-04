import 'failure_exception.dart';

class NoDataFound extends Failure {}

class VehicleDataEmpty extends Failure {
  VehicleDataEmpty() : super(errorMessage: "Preencha os dados corretamente.");
}

class NoUserInVehicleFound extends Failure {
  NoUserInVehicleFound()
      : super(errorMessage: "Os dados do usuário não foram localizados.");
}

class NoVehicleFound extends Failure {
  NoVehicleFound()
      : super(errorMessage: "Os dados do veiculo não foram localizados.");
}

class NoInternetConnection extends Failure {
  NoInternetConnection()
      : super(errorMessage: "Sem conexão com a internet no momento.");
}

class VehicleListNoInternetConnection extends NoInternetConnection {}

class VehicleListError extends Failure {
  VehicleListError(StackTrace stackTrace, String label, dynamic exception,
      String errorMessage)
      : super(
            stackTrace: stackTrace,
            label: label,
            exception: exception,
            errorMessage: errorMessage);
}
