class Tarefa {
  int id;
  String descricao;
  String obs;
  Tarefa(this.id, this.descricao, this.obs);

  @override
  String toString() {
    return 'Tarefa(descricao: $descricao, obs: $obs)';
  }
}