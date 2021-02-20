import '../db/database_provider.dart';

class Food {
  int id;
  String nome;
  String valor;
  bool comprado;

  Food({this.id, this.nome, this.valor, this.comprado});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_nome: nome,
      DatabaseProvider.COLUMN_valor: valor,
      DatabaseProvider.COLUMN_comprado: comprado ? 1 : 0
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Food.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    nome = map[DatabaseProvider.COLUMN_nome];
    valor = map[DatabaseProvider.COLUMN_valor];
    comprado = map[DatabaseProvider.COLUMN_comprado] == 1;
  }
}
