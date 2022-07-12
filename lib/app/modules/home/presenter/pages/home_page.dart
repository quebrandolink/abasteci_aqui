import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';
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
        title: const Text('Abasteci Aqui'),
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
              itemBuilder: (context, index) => ListTile(
                subtitle: Text(listFuel[index].address != null
                    ? listFuel[index].address!
                    : ""),
                tileColor: (index == 0)
                    ? Theme.of(context).colorScheme.surfaceVariant
                    : null,
                title: Text(
                  DateFormat('dd/MM/yyyy HH:mm', 'pt_BR')
                      .format(listFuel[index].date),
                ),
                onTap: () async {
                  await Modular.to
                      .pushNamed("/addFuel", arguments: listFuel[index]);
                  store.getList();
                },
              ),
            ),
          );
        },
        onError: (context, error) => Center(
          child: Text(
            "Ops, ${error?.message}",
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
