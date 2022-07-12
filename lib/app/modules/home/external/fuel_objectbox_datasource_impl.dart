import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/modules/home/infra/datasources/fuel_datasource.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';
import 'package:fuel_manager/database/objectbox.g.dart';
import 'package:fuel_manager/database/objectbox_database.dart';

class FuelObjectboxDatasourceImpl implements FuelDatasource {
  final ObjectBoxDatabase database;

  FuelObjectboxDatasourceImpl(this.database);

  Future<Box> getBox() async {
    final store = await database.getStore();
    return store.box<FuelEntity>();
  }

  @override
  Future<List<FuelEntity>> getFuelList() async {
    final box = await getBox();
    final builder = box.query()
      ..order(FuelEntity_.date, flags: Order.descending);
    final query = builder.build();
    final list = query.find() as List<FuelEntity>;
    if (list.isEmpty) {
      throw FuelException("Não foram encontrados dados salvos.");
    } else {
      return list;
    }
  }

  @override
  Future<bool> insert(FuelEntity model) async {
    final box = await getBox();
    final id = box.put(model);
    return id != 0 ? true : false;
  }

  @override
  Future<bool> delete(FuelEntity model) async {
    final box = await getBox();
    final success = box.remove(model.id);
    return success;
  }
}
