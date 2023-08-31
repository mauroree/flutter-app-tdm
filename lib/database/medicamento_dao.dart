import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medicamento.dart';

class MedicamentoDao {

  static const String _tableName = "medicamentos";
  static const String _id = "id";
  static const String _nome = "nome";
  static const String _descricao = "descricao";
  static const String _quantidade = "quantidade";
  static const String _horario = "horario";

  static const String _tableSql = 'CREATE TABLE medicamentos ( '
      ' id INTEGER PRIMARY KEY, '
      ' nome TEXT, '
      ' descricao TEXT, '
      ' quantidade TEXT, '
      ' horario TEXT)';

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'dbmedicamentos.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(_tableSql);
      },
      version: 2,
    );
  }

  Map<String, dynamic> toMap(Medicamento medicamento) {
    final Map<String, dynamic> medicamentoMap = Map();
    medicamentoMap[_nome] = medicamento.nome;
    medicamentoMap[_descricao] = medicamento.descricao;
    medicamentoMap[_quantidade] = medicamento.quantidade;
    medicamentoMap[_horario] = medicamento.horario;
    return medicamentoMap;
  }

  Future<int> save(Medicamento medicamento) async {
    final Database db = await getDatabase();
    Map<String, dynamic> medicamentoMap = toMap(medicamento);
    return db.insert(_tableName, medicamentoMap);
  }

  Future<int> update(Medicamento medicamento) async {
    final Database db = await getDatabase();
    Map<String, dynamic> medicamentoMap = toMap(medicamento);
    return db.update(_tableName, medicamentoMap, where: 'id = ?', whereArgs: [medicamento.id]);
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  List<Medicamento> toList(List<Map<String, dynamic>> result) {
    final List<Medicamento> medicamentos = [];
    for (Map<String, dynamic> row in result) {
      final Medicamento medicamento = Medicamento(
        row[_id],
        row[_nome],
        row[_descricao],
        row[_quantidade],
        row[_horario],
      );
      medicamentos.add(medicamento);
    }
    return medicamentos;
  }

  Future<List<Medicamento>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Medicamento> medicamentos = toList(result);
    return medicamentos;
  }
}
