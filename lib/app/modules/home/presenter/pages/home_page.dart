import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/shared/helpers/material_banner_menager.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../auth/presenters/stores/auth_store.dart';
import '../../domain/entities/fuel_entity.dart';
import '../../../../shared/exceptions/fuel_exception.dart';
import '../../../../shared/theme/theme_store.dart';
import '../../../splash/components/splash_widget_lottie.dart';
import '../components/fuel_list_item.dart';
import '../components/last_fuel_widget.dart';
import '../stores/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = Modular.get<HomeStore>();
  final themeStore = Modular.get<ThemeStore>();
  final authStore = Modular.get<AuthStore>();

  @override
  void initState() {
    store.getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
                builder: ((context) => SizedBox(
                      height: 380,
                      child: Column(
                        children: [
                          const SizedBox(height: Sizes.DIVISIONS * 2),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.primaryColor,
                              ),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(authStore.user!.photoUrl!),
                              ),
                            ),
                          ),
                          const SizedBox(height: Sizes.DIVISIONS),
                          Text(
                            authStore.user!.name!,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            authStore.user!.email!,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: Sizes.DIVISIONS),
                          ScopedBuilder<ThemeStore, Exception, bool>(
                              store: themeStore,
                              onState: (context, isDarkTheme) {
                                return SwitchListTile(
                                    value: isDarkTheme,
                                    title: const Text("MUDAR TEMA"),
                                    onChanged: (value) =>
                                        themeStore.changeTheme());
                              }),
                          const SizedBox(height: Sizes.DIVISIONS * 2),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                BannerMenager().showWarning(scaffoldKey,
                                    "DESEJA REALMENTE FAZER LOGOUT?",
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            primary: Colors.white),
                                        onPressed: () => authStore.signOut(),
                                        child: const Text("SIM"),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            primary: Colors.white),
                                        onPressed: () => ScaffoldMessenger.of(
                                                scaffoldKey.currentContext!)
                                            .hideCurrentMaterialBanner(),
                                        child: const Text("NÃO"),
                                      ),
                                    ]);
                              },
                              child: const Text("LOGOUT"),
                            ),
                          ),
                        ],
                      ),
                    )));
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

    RefreshController refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh() async {
      store.getList();
      refreshController.refreshCompleted();
      store.observer(
        onError: (error) => refreshController.loadFailed(),
        onState: (state) => state.isEmpty
            ? refreshController.loadNoData()
            : refreshController.loadComplete(),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: appBarHome,
      body: ScopedBuilder<HomeStore, FuelException, List<FuelEntity>>(
        store: store,
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
            controller: refreshController,
            onRefresh: _onRefresh,
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
          controller: refreshController,
          onRefresh: _onRefresh,
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
              .pushNamed("addfuel?lastVehicle=${store.lastVehicle}")
              .then((value) {
            debugPrint("value: $value");
            if (value != null) {
              store.getList();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({
    required this.listFuel,
    Key? key,
    this.isLoading = false,
  }) : super(key: key);

  final List<FuelEntity> listFuel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    animationConfiguration(int index, Widget child) =>
        AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: child,
          ),
        );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.DIVISIONS),
            AnimationLimiter(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: isLoading ? 4 : listFuel.length,
                  itemBuilder: (context, index) {
                    return animationConfiguration(
                      index,
                      Column(
                        children: [
                          const SizedBox(height: Sizes.DIVISIONS),
                          (index == 1)
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.DIVISIONS),
                                    child: Text(
                                        "Abastecimentos anteriores"
                                            .toUpperCase(),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ),
                                )
                              : const SizedBox(),
                          (index == 0)
                              ? LastFuelWidget(
                                  model: isLoading
                                      ? FuelEntity()
                                      : listFuel[index],
                                  isLoading: isLoading,
                                )
                              : FuelListItem(
                                  model: isLoading
                                      ? FuelEntity()
                                      : listFuel[index],
                                  isLoading: isLoading,
                                ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
