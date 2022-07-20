import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import '../auth/presenters/stores/auth_store.dart';
import 'components/splash_widget_lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final store = Modular.get<AuthStore>();

  @override
  void initState() {
    //aqui verifica se esta logado ou não
    store.checkLoggedUser.listen((user) {
      if (user != null) {
        Modular.to.navigate("/home/");
      } else {
        Modular.to.navigate("/auth/");
      }
    }).onError((e) => Modular.to.navigate("/auth/"));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashWidgetLottie(
        isNetwork: true,
        lottieFile: Constants.kloadingLottieAnimation,
      ),
    );
  }
}
