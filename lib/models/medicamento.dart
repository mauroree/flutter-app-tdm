class Medicamento {
  int id;
  String nome;
  String descricao;
  String quantidade;
  String horario;
  Medicamento(this.id, this.nome, this.descricao, this.quantidade, this.horario);

  @override
  String toString() {
    return 'Medicamento (nome: $nome: descricao: $descricao, quantidade: $quantidade, horario: $horario)';
  }
}