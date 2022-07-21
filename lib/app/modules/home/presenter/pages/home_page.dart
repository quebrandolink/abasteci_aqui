import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../auth/presenters/stores/auth_store.dart';
import '../../domain/entities/fuel_entity.dart';
import '../../../../shared/exceptions/fuel_exception.dart';
import '../../../../shared/theme/theme_store.dart';
import '../../../splash/components/splash_widget_lottie.dart';
import '../components/home_page_widget.dart';
import '../components/modal_profile_widget.dart';
import '../stores/fuel_store.dart';
import '../stores/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeStore = Modular.get<HomeStore>();
  final themeStore = Modular.get<ThemeStore>();
  final authStore = Modular.get<AuthStore>();
  final fuelStore = Modular.get<FuelStore>();

  @override
  void initState() {
    homeStore.getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBarHome = AppBar(
      toolbarHeight: 70,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 30,
          height: 30,
        ),
      ),
      title: Text(
        'ABASTECI AQUI',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Sizes.DIVISIONS),
                    topRight: Radius.circular(Sizes.DIVISIONS),
                  ),
                ),
                context: context,
                builder: ((context) => const ModalProfileWidget()));
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.primaryColor,
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(authStore.user!.photoUrl!),
              ),
            ),
          ),
        ),
        const SizedBox(width: Sizes.DIVISIONS),
      ],
    );

    return Scaffold(
      key: fuelStore.scaffoldKeyFuelStore,
      appBar: appBarHome,
      body: ScopedBuilder<HomeStore, FuelException, List<FuelEntity>>(
        store: homeStore,
        onLoading: (context) => const HomePageWidget(
          listFuel: [],
          isLoading: true,
        ),
        onState: (_, listFuel) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: const MaterialClassicHeader(
              backgroundColor: AppColors.primaryColor,
              color: Colors.white,
            ),
            controller: homeStore.refreshController,
            onRefresh: homeStore.onRefresh,
            child: (listFuel.isEmpty)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SplashWidgetLottie(
                        isNetwork: true,
                        lottieFile: Constants.kcarLottieAnimation,
                      ),
                      Text(
                        'Não há abastecimentos salvos.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : HomePageWidget(
                    listFuel: listFuel,
                    isLoading: false,
                  ),
          );
        },
        onError: (context, error) => SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: const MaterialClassicHeader(
            backgroundColor: AppColors.primaryColor,
            color: Colors.white,
          ),
          controller: homeStore.refreshController,
          onRefresh: homeStore.onRefresh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SplashWidgetLottie(
                isNetwork: true,
                lottieFile: Constants.kErrorLottieAnimation,
                message: error != null
                    ? "Ops, ${error.message}"
                    : "Ops, ocorreu um erro desconhecido.",
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Modular.to
              .pushNamed("addfuel?lastVehicle=${homeStore.lastVehicle}")
              .then((value) {
            if (value != null) {
              homeStore.getList();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
