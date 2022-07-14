import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../shared/theme/theme_store.dart';
import '../stores/home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = Modular.get<HomeStore>();
  final themeStore = Modular.get<ThemeStore>();

  @override
  void initState() {
    store.getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            icon: const Icon(Ionicons.refresh_circle_outline),
            tooltip: 'Atualizar',
            onPressed: () => store.getList(),
          ),
          ScopedBuilder<ThemeStore, Exception, bool>(
              store: Modular.get<ThemeStore>(),
              onState: (context, isDarkTheme) {
                return IconButton(
                  icon: Icon(isDarkTheme
                      ? Ionicons.star_outline
                      : Ionicons.sunny_outline),
                  tooltip: 'Change Theme',
                  onPressed: () => themeStore.changeTheme(),
                );
              }),
        ],
      ),
      body: ScopedBuilder<HomeStore, FuelException, List<FuelEntity>>(
        store: store,
        onState: (_, listFuel) {
          if (listFuel.isEmpty) {
            return const Center(
              child: Text(
                'Não há abastecimentos salvos.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: listFuel.length,
              itemBuilder: (context, index) => (index == 0)
                  ? LastFuelWidget(model: listFuel[index])
                  : FuelListItem(model: listFuel[index]),
            ),
          );
        },
        onError: (context, error) => Center(
          child: Text(
            error != null
                ? "Ops, ${error.message}"
                : "Ops, ocorreu um erro desconhecido.",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Modular.to.pushNamed("/addFuel");
          store.getList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FuelListItem extends StatelessWidget {
  const FuelListItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  final FuelEntity model;

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<HomeStore>();
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
                model.km != null ? "KM: ${model.km}" : "KM não cadastrado"),
          ),
          Expanded(
            child: Text(
              DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(model.date),
            ),
          ),
        ],
      ),
      subtitle: Text(model.address != null ? model.address! : ""),
      onTap: () async {
        await Modular.to.pushNamed("/addFuel", arguments: model);
        store.getList();
      },
    );
  }
}

class LastFuelWidget extends StatelessWidget {
  const LastFuelWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final FuelEntity model;

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<HomeStore>();
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.DIVISIONS),
          child: Column(
            children: [
              const SizedBox(height: Sizes.DIVISIONS),
              Text(
                "Último abastecimento".toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(model.date),
              ),
              const SizedBox(height: Sizes.DIVISIONS),
              Text((model.km != null)
                  ? "KM: ${model.km}"
                  : "KM: Não cadastrado"),
              const SizedBox(height: Sizes.DIVISIONS),
              Text(model.address != null ? model.address! : "",
                  textAlign: TextAlign.center),
              const SizedBox(height: Sizes.DIVISIONS),
            ],
          ),
        ),
      ),
      onTap: () async {
        await Modular.to.pushNamed("/addFuel", arguments: model);
        store.getList();
      },
    );
  }
}
