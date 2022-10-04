//SignInScreen

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/auth/domain/entities/user_entity.dart';
import 'package:fuel_manager/app/modules/home/presenter/components/new_fuel_widget.dart';
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
      body: ScopedBuilder<AuthStore, Failure, UserEntity>(
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
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Sizes.DIVISIONS),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.DIVISIONS * 3),
            Center(
              child: Image.asset(
                "assets/images/fuel-marker.png",
                height: 150,
              ),
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            Center(
              child: Text(
                "ABASTECI AQUI",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            Text(
              "Faça login para começar a acompanhar seus abastecimentos.",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            TextFieldWidget(
              controller: store.emailController,
              hintText: "Email",
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            TextFieldWidget(
              controller: store.passwordController,
              hintText: "Senha",
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    onPressed: () => store.signIn(),
                    child: const Text("ENTRAR"))),
            const SizedBox(height: Sizes.DIVISIONS * 2),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(height: 2, width: 50, color: Colors.grey[700]),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sizes.DIVISIONS),
                child:
                    Text("OU", style: Theme.of(context).textTheme.titleSmall),
              ),
              Container(height: 2, width: 50, color: Colors.grey[700]),
            ]),
            const SizedBox(height: Sizes.DIVISIONS * 2),
            // Center(
            //   child: Text(
            //     "ENTRE COM AS REDES SOCIAIS",
            //     style: Theme.of(context).textTheme.titleSmall,
            //   ),
            // ),
            // const SizedBox(height: Sizes.DIVISIONS),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: store.signInGoogle,
                    icon: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                        child: const Icon(Ionicons.logo_google)),
                  ),
                ),
                const SizedBox(width: Sizes.DIVISIONS * 2),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      SnackbarMenager().showInfo(context,
                          "Login com Facebook ainda não implementado.");
                    },
                    icon: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                        child: const Icon(Ionicons.logo_facebook)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
