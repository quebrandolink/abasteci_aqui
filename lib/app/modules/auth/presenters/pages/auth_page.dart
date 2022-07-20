//SignInScreen

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/auth/domain/entities/user_entity.dart';
import 'package:fuel_manager/app/shared/exceptions/failure_exception.dart';
import '../../../../shared/exceptions/auth_exception.dart';
import '../../../splash/components/splash_widget_lottie.dart';
import '../stores/auth_store.dart';
import 'package:fuel_manager/app/shared/helpers/snackbar_menager.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:ionicons/ionicons.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final store = Modular.get<AuthStore>();

  @override
  void initState() {
    store.observer(
        onError: (error) => SnackbarMenager().showError(
            context,
            (error is NoInternetConnection)
                ? "Sem conexão com a internet."
                : (error is ErrorGoogleSignIn)
                    ? "Usuário não localizado. Tente novamente."
                    : error.errorMessage),
        onState: (state) {
          SnackbarMenager().showSuccess(
              context, "login efetuado com sucesso. ${state.name}");
          Modular.to.navigate("/home/");
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.bottomLeft,
            //   end: Alignment.topRight,
            //   colors: [
            //     AppColors.primaryColor.withOpacity(.2),
            //     Colors.white,
            //   ],
            // ),
            ),
        child: ScopedBuilder<AuthStore, Failure, UserEntity>(
            store: store,
            onLoading: ((context) => const SplashWidgetLottie(
                  isNetwork: true,
                  lottieFile: Constants.kloadingLottieAnimation,
                  size: 100,
                )),
            onError: (context, error) => const AuthWidget(),
            onState: (context, user) {
              if (user.email != null) {
                return const SplashWidgetLottie(
                  isNetwork: true,
                  lottieFile: Constants.kloadingLottieAnimation,
                  size: 100,
                );
              }
              return const AuthWidget();
            }),
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<AuthStore>();
    return Padding(
      padding: const EdgeInsets.all(Sizes.DIVISIONS),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              "assets/images/fuel-marker.png",
              height: 180,
            ),
          ),
          const SizedBox(height: Sizes.DIVISIONS * 3),
          Text(
            "Olá,",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "Seja bem vindo",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "Faça login para começar a acompanhar seus abastecimentos.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          ),
          const SizedBox(height: Sizes.DIVISIONS * 3),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                store.signIn();
              },
              icon: const Icon(Ionicons.logo_google, color: Colors.red),
              label: const Text("Login com Google"),
            ),
          )
        ],
      ),
    );
  }
}
